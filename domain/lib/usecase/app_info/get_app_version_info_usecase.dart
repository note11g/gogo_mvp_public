import '../../entity/app_info/app_version_info.dart';
import '../../repository/app_info_repository.dart';

class GetAppVersionInfoUseCase {
  final AppInfoRepository _appInfoRepository;

  const GetAppVersionInfoUseCase(this._appInfoRepository);

  Future<AppVersionInfo> call() async {
    return await _appInfoRepository.getAppVersionInfo();
  }
}
