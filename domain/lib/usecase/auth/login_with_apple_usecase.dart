import 'package:gogo_mvp_domain/entity/auth/oauth_payload.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'package:gogo_mvp_domain/repository/auth_repository.dart';

class LoginWithAppleUseCase {
  final AuthRepository _authRepository;

  const LoginWithAppleUseCase(this._authRepository);

  Future<Me?> call(AppleLoginPayload payload) async {
    return _authRepository.loginWithApple(payload);
  }
}
