import 'package:gogo_mvp_domain/entity/user/me.dart';

import '../../repository/auth_repository.dart';

class UpdateMyInfoUseCase {
  final AuthRepository _authRepository;

  const UpdateMyInfoUseCase(this._authRepository);

  Future<void> call({required Me me}) {
    return _authRepository.updateMyInfo(me);
  }
}
