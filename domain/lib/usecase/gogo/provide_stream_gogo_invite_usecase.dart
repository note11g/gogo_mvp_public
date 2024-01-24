import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';
import 'package:gogo_mvp_domain/repository/gogo_repository.dart';

class ProvideStreamGogoInviteUseCase {
  final GogoRepository _gogoRepository;

  const ProvideStreamGogoInviteUseCase(this._gogoRepository);

  Stream<List<GogoInfo>> call() {
    return _gogoRepository.streamInviteGogoRequests();
  }
}
