import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gogo_mvp_domain/entity/auth/login_platform.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'package:gogo_mvp_domain/entity/user/soma_role.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _flutterSecureStorage;
  final FirebaseAuth _firebaseAuth;

  AuthLocalDataSource(this._flutterSecureStorage, this._firebaseAuth);

  /// Firebase Auth에 저장된 내 회원 정보 가져오는 firebase API 호출 함수
  Me? getFirebaseUserInfo() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return Me(
        id: user.uid,
        name: user.displayName ?? "",
        profileImageUrl: user.photoURL ?? "",
        email: user.email ?? "",
        somaRole: SomaRole.none,
        tags: []);
  }

  String? getUserId() => _firebaseAuth.currentUser?.uid;

  GoLoginPlatform getLoginPlatform() {
    return switch (
        _firebaseAuth.currentUser?.providerData.firstOrNull?.providerId) {
      "apple.com" => GoLoginPlatform.apple,
      _ => GoLoginPlatform.kakao,
    };
  }

  Future<void> saveAppleRefreshToken(String refreshToken) {
    return _flutterSecureStorage.write(
        key: "apple_refresh_token", value: refreshToken);
  }

  Future<String?> getAppleRefreshToken() {
    return _flutterSecureStorage.read(key: "apple_refresh_token");
  }

  Future<void> deleteAppleRefreshToken() {
    return _flutterSecureStorage.delete(key: "apple_refresh_token");
  }
}
