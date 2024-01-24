import 'package:gogo_mvp_domain/entity/app_info/app_version_info.dart';
import 'package:gogo_mvp_domain/repository/app_info_repository.dart';
import '../datasource/app/app_info_remote_data_source.dart';

class AppInfoRepositoryImpl implements AppInfoRepository {
  final AppInfoRemoteDataSource _appInfoRemoteDataSource;

  AppInfoRepositoryImpl(this._appInfoRemoteDataSource);

  @override
  Future<AppVersionInfo> getAppVersionInfo() {
    return _appInfoRemoteDataSource.getAppVersionInfo();
  }

  @override
  Future<List<String>> getTags() {
    return _appInfoRemoteDataSource.getTags();
  }
}
