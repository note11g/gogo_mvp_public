import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:gogo_mvp/presentation/src/core/global_container/main_container.dart';

class ForegroundNotificationHelper {
  static MainContainer get _mainContainer => GetIt.I.get<MainContainer>();

  static Future<void> initialize() async {
    _subscribeForegroundMessage();
  }

  static void _subscribeForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_onMessage);
  }

  static void _onMessage(RemoteMessage message) {
    // todo : show UI
    final isChat = message.data["noti_type"] == "chat";
    final gogoId = message.data["gogoId"] as String?;
    if (isChat && gogoId != null) {
      _mainContainer.changeGogoRoomLastUpdateTime(gogoId, DateTime.now());
    }
  }
}
