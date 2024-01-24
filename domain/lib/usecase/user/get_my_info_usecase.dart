import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'package:gogo_mvp_domain/repository/auth_repository.dart';

class GetMyInfoUseCase {
  final AuthRepository _authRepository;

  const GetMyInfoUseCase(this._authRepository);

  Future<Me?> call() async {
    return await _authRepository.getMyInfo();
  }
}
