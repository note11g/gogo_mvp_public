import 'package:gogo_mvp_domain/repository/auth_repository.dart';

class SignOutUserUseCase {
  final AuthRepository _authRepository;

  const SignOutUserUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.signOut();
  }
}
