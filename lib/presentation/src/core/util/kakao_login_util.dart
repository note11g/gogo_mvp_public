import 'package:gogo_mvp/initialize/keys/api_options.dart';
import 'package:gogo_mvp_domain/entity/auth/oauth_payload.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginUtil {
  static Future<KakaoLoginPayload> signInWithKakao() async {
    final canUseKakaoTalkApp = await isKakaoTalkInstalled();
    final getAuthCode = canUseKakaoTalkApp
        ? AuthCodeClient.instance.authorizeWithTalk
        : AuthCodeClient.instance.authorize;
    final authCode =
        await getAuthCode(redirectUri: DefaultKakaoSdkOptions.redirectUri);
    return KakaoLoginPayload(authCode: authCode);
  }
}
