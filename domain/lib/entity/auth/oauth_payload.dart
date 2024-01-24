sealed class OAuthLoginPayload {}

class AppleLoginPayload extends OAuthLoginPayload {
  final String authCode;
  final String identityToken;
  final String rawNonce;
  final String? fullName;

  AppleLoginPayload({
    required this.authCode,
    required this.identityToken,
    required this.rawNonce,
    required this.fullName,
  });
}

class KakaoLoginPayload extends OAuthLoginPayload {
  final String authCode;

  KakaoLoginPayload({required this.authCode});
}
