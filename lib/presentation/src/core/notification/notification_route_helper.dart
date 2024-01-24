import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:gogo_mvp/presentation/presentation.dart';

class OutboundRouteHelper {
  static GoGoRouteHelper get _routeHelper => GetIt.I.get();

  static Future<void> initialize() async {
    await _checkOpenedFromFcm();
    await _checkOpenedFromDynamicLink();
    _subscribeOpenedFromFcm();
    _subscribeOpenedFromDynamicLink();
  }

  /* ----- FCM ----- */

  static Future<void> _checkOpenedFromFcm() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message == null) return;
    _onMessage(message);
  }

  static void _subscribeOpenedFromFcm() {
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessage);
  }

  static void _onMessage(RemoteMessage message) {
    final String? route = message.data["route_name"];
    if (route == null) return;
    final recentRoute = _routeHelper.nowLocation;
    if (recentRoute == route) return;
    log("route: $route, recent: $recentRoute", name: "FCM Routing");
    _routeHelper.push(route);
  }

  /* ----- Dynamic Links ----- */

  static Future<void> _checkOpenedFromDynamicLink() async {
    final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink == null) return;
    _onDynamicLink(initialLink);
  }

  static Future<void> _subscribeOpenedFromDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink.listen(_onDynamicLink);
  }

  static void _onDynamicLink(PendingDynamicLinkData data) {
    final params = data.link.queryParameters;
    print("here: ${data.asMap()}, params: $params");
    final linkType = params["link_type"];

    switch (linkType) {
      case "invite":
        _onInviteLink(params);
        break;
      default:
        return;
    }
  }

  static void _onInviteLink(Map<String, String> params) {
    final inviteCode = params["inv_code"];
    if (inviteCode == null) return;
    _routeHelper.push(GoPages.askJoin(id: inviteCode, isLinkInvite: true));
  }
}
