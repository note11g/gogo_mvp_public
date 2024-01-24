import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:gogo_mvp/analytics/amplitude_util.dart';
import 'package:gogo_mvp/initialize/di_initialize.dart';
import 'package:gogo_mvp/initialize/keys/api_options.dart';
import 'package:gogo_mvp/presentation/src/core/notification/foreground_notification_helper.dart';
import 'package:gogo_mvp/presentation/src/core/notification/notification_route_helper.dart';
import 'package:gogo_mvp/presentation/src/core/routing/routing.dart';
import 'package:gogo_mvp/presentation/src/core/util/update_util.dart';
import 'package:gogo_mvp_domain/usecase/app_info/get_app_version_info_usecase.dart';
import 'package:gogo_mvp_domain/usecase/notification/update_fcm_token_usecase.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class InitializeUtil {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initializeFirebase(); // depends on ensureInitialized()
    await DiInitializer.init(
        // depends on _initializeFirebase()
        onContainerReady: _initializeWhenAfterFirstPageBuilt);
    _initializeKakaoLogin();
    _initializeI18n();
    _initializeSystemUI();
    await AmplitudeUtil.init();
    await _requestPermission();
    await _initializeFcm(); // depends on _requestPermission()
  }

  /// only called at login done time. (welcome page)
  static Future<void> initializeFcmTokenWhenLogin() => _initializeFcm();

  /* ----- Private Methods ----- */

  static Future<void> _initializeWhenAfterFirstPageBuilt() async {
    await OutboundRouteHelper.initialize();
    await ForegroundNotificationHelper.initialize();
    await _checkNeedUpdate();
  }

  static Future<void> _checkNeedUpdate() async {
    await UpdateUtil.checkNeedUpdate(
        getVersionInfo: GetIt.I.get<GetAppVersionInfoUseCase>(),
        onNeedUpdate: (info) => GetIt.I
            .get<GoGoRouteHelper>()
            .push(GoPages.needUpdate, extra: info));
  }

  static Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  static void _initializeKakaoLogin() {
    KakaoSdk.init(
      nativeAppKey: DefaultKakaoSdkOptions.nativeClientId,
      javaScriptAppKey: DefaultKakaoSdkOptions.javascriptClientId,
    );
  }

  static void _initializeI18n() {
    Intl.defaultLocale = 'ko_KR';
    initializeDateFormatting('ko_KR');
  }

  static void _initializeSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  static Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission();
  }

  static Future<void> _initializeFcm() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      final updateFcmToken = GetIt.I.get<UpdateFcmTokenUseCase>();
      final tokenChanged = await updateFcmToken(token: token);
      log("tokenChanged: $tokenChanged", name: "initializeFcm");
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, e.stackTrace, reason: "FirebaseException Catched.");
    } on FlutterError catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, e.stackTrace, reason: "FlutterError Catched.");
    }
  }
}
