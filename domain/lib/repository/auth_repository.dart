import 'package:gogo_mvp_domain/entity/auth/login_platform.dart';
import 'package:gogo_mvp_domain/entity/auth/oauth_payload.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';

abstract interface class AuthRepository {
  /// if return is null, first register.
  Future<Me?> loginWithKakao(KakaoLoginPayload payload);

  Future<Me?> loginWithApple(AppleLoginPayload payload);

  Future<void> updateMyInfo(Me me);

  Future<Me?> getMyInfo();

  /// 처음 회원가입 시, oauth 기본 정보만 저장된 default user 정보를 반환한다.
  Me? getMyMinimalAuthInfo();

  Future<void> signOut();

  Future<void> deleteAccount({
    required Future<OAuthLoginPayload> Function(GoLoginPlatform platform)
        onNeedReAuthenticate,
  });
}
