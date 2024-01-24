import 'package:gogo_mvp_domain/repository/gogo_repository.dart';

class DenyGogoInviteUseCase {
  final GogoRepository _gogoRepository;

  const DenyGogoInviteUseCase(this._gogoRepository);

  Future<void> call({required String gogoId}) async {
    return _gogoRepository.denyGogoInvite(gogoId);
  }
}
