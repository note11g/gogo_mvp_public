import 'package:gogo_mvp_domain/entity/user/soma_role.dart';

import '../../repository/auth_repository.dart';

class CheckLoginUseCase {
  final AuthRepository _authRepository;

  const CheckLoginUseCase(this._authRepository);

  Future<bool> call() async {
    final user = await _authRepository.getMyInfo();
    if (user?.isNewAccount == true) return false;
    return user != null;
  }
}
