import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:gogo_mvp_domain/entity/auth/oauth_payload.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginUtil {
  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<AuthorizationCredentialAppleID> _getAppleCredential({
    required List<AppleIDAuthorizationScopes> scopes,
    required String rawNonce,
  }) {
    final nonce = _sha256ofString(rawNonce);
    return SignInWithApple.getAppleIDCredential(scopes: scopes, nonce: nonce);
  }

  static Future<AppleLoginPayload> signInWithApple() async {
    final nonce = _generateNonce();
    final authCredential = await _getAppleCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ], rawNonce: nonce);

    final fullName = authCredential.familyName != null
        ? "${authCredential.familyName}${authCredential.givenName}"
        : null;

    return AppleLoginPayload(
        authCode: authCredential.authorizationCode,
        identityToken: authCredential.identityToken!,
        rawNonce: nonce,
        fullName: fullName);
  }
}
