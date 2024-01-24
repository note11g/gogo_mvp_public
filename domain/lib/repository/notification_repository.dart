abstract interface class NotificationRepository {
  Future<bool> updateFcmTokenWhenChanged(String token);
}
