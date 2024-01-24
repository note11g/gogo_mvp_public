import 'package:gogo_mvp_domain/entity/auth/login_platform.dart';
import 'package:gogo_mvp_domain/entity/auth/oauth_payload.dart';
import 'package:gogo_mvp_domain/repository/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository _authRepository;

  const DeleteAccountUseCase(this._authRepository);

  Future<void> call({
    required Future<OAuthLoginPayload> Function(GoLoginPlatform platform)
        onNeedReAuthenticate,
  }) {
    return _authRepository.deleteAccount(
        onNeedReAuthenticate: onNeedReAuthenticate);
  }
}
