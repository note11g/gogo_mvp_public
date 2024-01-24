import '../../repository/notification_repository.dart';

class UpdateFcmTokenUseCase {
  final NotificationRepository _notificationRepository;

  const UpdateFcmTokenUseCase(this._notificationRepository);

  Future<bool> call({required String token}) async {
    return await _notificationRepository.updateFcmTokenWhenChanged(token);
  }
}
