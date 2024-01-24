import 'dart:developer' show log;

import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogo_mvp/initialize/keys/api_options.dart';

class AmplitudeUtil {
  static late final Amplitude _amplitude;

  static Future<void> init() async {
    _amplitude =
        Amplitude.getInstance(instanceName: DefaultAmplitudeSdkOptions.name);
    await _amplitude.init(DefaultAmplitudeSdkOptions.apiKey);
  }

  static Future<void> trackWithPath(
    String event, {
    UserAction action = UserAction.click,
    Map<String, String>? properties,
    required BuildContext context,
  }) async {
    final sendProperties = {
      'page': _getPathWithBuildContext(context),
      ...?properties,
    };
    await track(event, action: action, properties: sendProperties);
  }

  static Future<void> track(
    String event, {
    UserAction action = UserAction.click,
    Map<String, dynamic>? properties,
  }) async {
    final eventType = "${action.name}-$event";
    final eventProperties = {'action': action.name, ...?properties};
    await _amplitude.logEvent(eventType, eventProperties: eventProperties);
    log("event logged! : $eventType, $properties");
  }

  static Future<void> setUserId(String userId) async {
    await _amplitude.setUserId(userId);
  }

  static Future<void> setUserProperties(Map<String, dynamic> properties) async {
    await _amplitude.setUserProperties(properties);
  }

  static String _getPathWithBuildContext(BuildContext context) =>
      ModalRoute.of(context)?.settings.name ?? "unknown";

  AmplitudeUtil._();
}

enum UserAction {
  click,
  enter;
}
