import 'package:gogo_mvp_domain/entity/auth/oauth_payload.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';

import '../../repository/auth_repository.dart';

class LoginWithKakaoUseCase {
  final AuthRepository _authRepository;

  const LoginWithKakaoUseCase(this._authRepository);

  Future<Me?> call(KakaoLoginPayload payload) {
    return _authRepository.loginWithKakao(payload);
  }
}
