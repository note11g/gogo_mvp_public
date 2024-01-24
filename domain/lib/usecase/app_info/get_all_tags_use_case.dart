import '../../repository/app_info_repository.dart';

class GetAllTagsUseCase {
  final AppInfoRepository _appInfoRepository;

  const GetAllTagsUseCase(this._appInfoRepository);

  Future<List<String>> call() async {
    return await _appInfoRepository.getTags();
  }
}
