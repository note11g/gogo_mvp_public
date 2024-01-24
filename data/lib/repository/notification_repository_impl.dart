import 'package:gogo_mvp_data/datasource/app/app_local_data_source.dart';
import 'package:gogo_mvp_data/datasource/auth/auth_local_data_source.dart';
import 'package:gogo_mvp_domain/repository/notification_repository.dart';
import 'package:gogo_mvp_data/datasource/notification/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _notificationRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final AppLocalDataSource _appLocalDataSource;

  NotificationRepositoryImpl(this._notificationRemoteDataSource,
      this._authLocalDataSource, this._appLocalDataSource);

  @override
  Future<bool> updateFcmTokenWhenChanged(String token) async {
    final uid = _authLocalDataSource.getUserId();
    if (uid == null) return false;

    final oldToken = await _appLocalDataSource.getFcmToken();
    if (oldToken == token) return false;

    await _appLocalDataSource.setFcmToken(token);
    return _notificationRemoteDataSource.updateFcmToken(
        uid: uid, token: token, oldToken: oldToken);
  }
}
