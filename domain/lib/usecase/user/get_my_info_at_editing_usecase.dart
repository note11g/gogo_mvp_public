import 'package:gogo_mvp_domain/entity/user/me.dart';

import '../../repository/auth_repository.dart';

class GetMyInfoAtEditingUseCase {
  final AuthRepository _authRepository;

  const GetMyInfoAtEditingUseCase(this._authRepository);

  Future<Me> call() async {
    final me = await _authRepository.getMyInfo();
    return me == null || me.isNewAccount
        ? _authRepository.getMyMinimalAuthInfo()!
        : me;
  }
}
