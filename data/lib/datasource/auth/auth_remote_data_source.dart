import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:dio/dio.dart';
import 'package:gogo_mvp_data/datasource/data_source_url.dart';
import 'package:gogo_mvp_domain/entity/user/soma_role.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  final FirebaseFirestore _firestore;
  final f_auth.FirebaseAuth _firebaseAuth;

  const AuthRemoteDataSource(this._dio, this._firestore, this._firebaseAuth);

  CollectionReference get _userDB => _firestore.collection("users");

  /// 1-a. 인가코드로 Firebase Custom token 발급
  Future<String> getFirebaseTokenWithKakaoAuthCode(String authCode) async {
    assert(authCode.isNotEmpty);
    final response = await _dio
        .post("${DataSourceUrl.socialAuthApi}/kakao", data: {"code": authCode});
    if (response.statusCode != 200) {
      throw Exception("Failed to get firebase token");
    }
    return response.data["firebaseToken"] as String;
  }

  /// 1-b. 인가코드로 Apple Refresh Token 발급
  Future<String?> getAppleRefreshToken(String authCode) async {
    assert(authCode.isNotEmpty);
    final response = await _dio.post(
        "${DataSourceUrl.socialAuthApi}/apple/refresh_token",
        data: {"code": authCode});
    if (response.statusCode != 200) {
      throw Exception("Failed to get apple refresh token");
    }
    return response.data["refreshToken"] as String?;
  }

  /// 2-a. Firebase Custom token으로 Firebase Auth 로그인
  Future<f_auth.User?> signInWithFirebaseToken(String firebaseToken) async {
    assert(firebaseToken.isNotEmpty);
    return await _firebaseAuth
        .signInWithCustomToken(firebaseToken)
        .then((credential) => credential.user);
  }

  /// 2-b. Apple Refresh Token으로 Firebase Auth 로그인
  Future<f_auth.User?> signInWithAppleIdentifyToken(String identityToken,
      {required String rawNonce, required String? fullName}) async {
    assert(rawNonce.isNotEmpty);
    final appleCredential = _getAppleCredential(identityToken, rawNonce);
    final userCredential =
        await _firebaseAuth.signInWithCredential(appleCredential);
    await userCredential.user?.updateDisplayName(fullName);
    return userCredential.user;
  }

  f_auth.OAuthCredential _getAppleCredential(
      String identityToken, String rawNonce) {
    return f_auth.OAuthProvider("apple.com")
        .credential(idToken: identityToken, rawNonce: rawNonce);
  }

  /// 3. 회원 정보 수정
  ///
  /// use user.copyWith() to update user info
  Future<void> updateUserInfo(Me me) async {
    final uid = _firebaseUser!.uid;
    final email = _firebaseUser!.email ?? "no-email";
    final updatedUser = me.copyWith(id: uid, email: email);
    await _userDB.doc(uid).set(updatedUser.toJson());
  }

  /// 4. Firebase Firestore에 저장된 내 회원 정보
  Future<Me?> getMe() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return null;

    final snapshot = await _userDB.doc(uid).get();
    try {
      return snapshot.exists ? Me.fromJson(snapshot.data()!) : null;
    } catch (e) {
      return null;
    }
  }

  /// 5. Apple Refresh Token Revoke
  Future<void> revokeAppleRefreshToken(String refreshToken) async {
    assert(refreshToken.isNotEmpty);
    final response = await _dio.post(
        "${DataSourceUrl.socialAuthApi}/apple/revoke_token",
        data: {"refreshToken": refreshToken});
    if (response.statusCode != 200) {
      throw Exception("Failed to revoke apple refresh token");
    }
  }

  /// 채팅이나 고고 등에서 처리가 되어있지 않아,
  /// 오류가 발생할 수 있으므로 delete 대신 비식별화 처리.
  Future<void> removeAllData() async {
    final uid = _firebaseUser!.uid;
    final me = await getMe();
    await _userDB.doc(uid).set(me!.copyWith(
          somaRole: SomaRole.none,
          name: "탈퇴한 사용자",
          profileImageUrl: "",
          tags: [],
        ).toJson());
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  Future<void> deleteAccount() => _firebaseUser!.delete();

  f_auth.User? get _firebaseUser => _firebaseAuth.currentUser;
}
