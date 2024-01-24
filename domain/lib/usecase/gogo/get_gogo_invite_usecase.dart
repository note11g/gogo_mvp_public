import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';
import 'package:gogo_mvp_domain/repository/gogo_repository.dart';

class GetGogoInviteUseCase {
  final GogoRepository _gogoRepository;

  const GetGogoInviteUseCase(this._gogoRepository);

  Future<List<GogoInfo>> call() {
    return _gogoRepository.getInvitedGogoRequest();
  }
}
