import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';
import 'package:gogo_mvp_domain/repository/gogo_repository.dart';

class GetGogoInfoUseCase {
  final GogoRepository _gogoRepository;

  const GetGogoInfoUseCase(this._gogoRepository);

  Future<GogoInfo?> call({required String gogoId}) async {
    return _gogoRepository.getGogoInfo(gogoId);
  }
}
