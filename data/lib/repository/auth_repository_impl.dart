import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogo_mvp_data/datasource/auth/auth_local_data_source.dart';
import 'package:gogo_mvp_domain/entity/auth/login_platform.dart';
import 'package:gogo_mvp_domain/entity/auth/oauth_payload.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'package:gogo_mvp_domain/repository/auth_repository.dart';
import '../datasource/auth/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<Me?> loginWithKakao(KakaoLoginPayload payload) async {
    final firebaseToken = await _authRemoteDataSource
        .getFirebaseTokenWithKakaoAuthCode(payload.authCode);
    final firebaseUser =
        await _authRemoteDataSource.signInWithFirebaseToken(firebaseToken);
    assert(firebaseUser != null);
    return await _authRemoteDataSource.getMe();
  }

  @override
  Future<Me?> loginWithApple(AppleLoginPayload payload) async {
    final refreshToken =
        await _authRemoteDataSource.getAppleRefreshToken(payload.authCode);
    if (refreshToken == null) throw FlutterError("refresh token is null");
    await _authLocalDataSource.saveAppleRefreshToken(refreshToken);

    final firebaseUser = await _authRemoteDataSource
        .signInWithAppleIdentifyToken(payload.identityToken,
            rawNonce: payload.rawNonce, fullName: payload.fullName);
    if (firebaseUser == null) throw FlutterError("firebase user is null");
    return await _authRemoteDataSource.getMe();
  }

  @override
  Future<Me?> getMyInfo() {
    return _authRemoteDataSource.getMe();
  }

  @override
  Future<void> updateMyInfo(Me me) {
    return _authRemoteDataSource.updateUserInfo(me);
  }

  @override
  Me? getMyMinimalAuthInfo() {
    return _authLocalDataSource.getFirebaseUserInfo();
  }

  @override
  Future<void> signOut() {
    return _authRemoteDataSource.signOut();
  }

  @override
  Future<void> deleteAccount({
    required Future<OAuthLoginPayload> Function(GoLoginPlatform platform)
        onNeedReAuthenticate,
  }) async {
    await _authRemoteDataSource.removeAllData();
    try {
      await _authRemoteDataSource.deleteAccount();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        await _reAuthenticate(onNeedReAuthenticate);
        await _authRemoteDataSource.deleteAccount();
      } else {
        rethrow;
      }
    }
    if (Platform.isIOS) await _removeAppleRefreshToken();
  }

  Future<void> _reAuthenticate(
      Future<OAuthLoginPayload> Function(GoLoginPlatform platform)
          onNeedReAuthenticate) async {
    final platform = _authLocalDataSource.getLoginPlatform();
    final payload = await onNeedReAuthenticate(platform);
    final _ = await switch (payload) {
      KakaoLoginPayload() => loginWithKakao(payload),
      AppleLoginPayload() => loginWithApple(payload),
    };
  }

  Future<void> _removeAppleRefreshToken() async {
    if (!Platform.isIOS) return;
    final refreshToken = await _authLocalDataSource.getAppleRefreshToken();
    if (refreshToken != null) {
      await _authRemoteDataSource.revokeAppleRefreshToken(refreshToken);
      await _authLocalDataSource.deleteAppleRefreshToken();
    }
  }
}
