import '../entity/app_info/app_version_info.dart';

abstract interface class AppInfoRepository {
  Future<AppVersionInfo> getAppVersionInfo();

  /// 회원 정보 수정 페이지에서만 사용한다.
  Future<List<String>> getTags();
}