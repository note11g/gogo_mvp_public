import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gogo_mvp/analytics/amplitude_util.dart';
import 'package:gogo_mvp/initialize/initialize_util.dart';
import 'package:gogo_mvp/presentation/src/core/global_container/main_container.dart';
import 'package:gogo_mvp/presentation/src/core/routing/routing.dart';
import 'package:gogo_mvp/presentation/src/core/util/apple_login_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/kakao_login_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/loading_util.dart';
import 'package:gogo_mvp/presentation/src/design/color/go_color.dart';
import 'package:gogo_mvp/presentation/src/design/typo/typo.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'package:gogo_mvp_domain/usecase/auth/login_with_apple_usecase.dart';
import 'package:gogo_mvp_domain/usecase/auth/login_with_kakao_usecase.dart';
import 'package:gogo_mvp/presentation/src/design/component/components.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
          _graphicImageSection(),
          _buttonSection(),
        ])));
  }

  Widget _graphicImageSection() => Expanded(
      flex: 2,
      child: LayoutBuilder(builder: (context, constraints) {
        final imageWidget =
            SvgPicture.asset("assets/images/welcome_vector.svg");

        if (constraints.maxWidth > 500) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: imageWidget);
        }

        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 48),
            child: SizedBox(
                width: double.infinity,
                child: AspectRatio(
                    aspectRatio: 1.23,
                    // 312x252 (세로 잘리지 않게 여유있게 잡아둠)
                    child: imageWidget)));
      }));

  Widget _buttonSection() => Expanded(
      flex: 1,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _socialLoginButton(
                text: "카카오로 계속하기",
                textColor: GoColors.black,
                color: const Color(0xFFFEE500),
                iconName: "kakao",
                context: context,
                loginWithOAuth: _requestLoginWithKakao),
            if (Platform.isIOS)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _socialLoginButton(
                    text: "Apple로 계속하기",
                    textColor: GoColors.white,
                    color: GoColors.black,
                    iconName: "apple",
                    context: context,
                    loginWithOAuth: _requestLoginWithApple),
              ),
          ]));

  @override
  void initState() {
    super.initState();
    AmplitudeUtil.track("welcome_page", action: UserAction.enter);
  }

  Widget _socialLoginButton({
    required String text,
    required Color textColor,
    required Color color,
    required String iconName,
    required BuildContext context,
    required Future<Me?> Function() loginWithOAuth,
  }) {
    return RawButton(
        onTap: () => _loginButtonOnTappedWithUI(
            loginWithOAuth: loginWithOAuth, context: context),
        fillWidth: true,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        color: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GoIcon(name: iconName, size: 18),
              const GoSpacer(16),
              Text(text, style: GoTypos.socialLoginButton(color: textColor)),
            ]));
  }

  void _loginButtonOnTappedWithUI({
    required Future<Me?> Function() loginWithOAuth,
    required BuildContext context,
  }) {
    AmplitudeUtil.trackWithPath("login_button", context: context);
    context.load(() => _loginButtonOnTapped(
          loginWithOAuth: loginWithOAuth,
          onNewUser: () => context.go(GoPages.profileSetting),
          hasAccount: () => context.go(GoPages.home),
        ));
  }

  Future<void> _loginButtonOnTapped({
    required Future<Me?> Function() loginWithOAuth,
    required VoidCallback onNewUser,
    required VoidCallback hasAccount,
  }) async {
    final user = await loginWithOAuth();
    await InitializeUtil.initializeFcmTokenWhenLogin();
    if (user == null || user.isNewAccount) {
      onNewUser();
    } else {
      await AmplitudeUtil.setUserId(user.id);
      GetIt.I.get<MainContainer>().updateCachedMyInfo(user);
      hasAccount();
    }
  }

  Future<Me?> _requestLoginWithKakao() async {
    try {
      final info = await KakaoLoginUtil.signInWithKakao();
      return GetIt.I.get<LoginWithKakaoUseCase>().call(info);
    } catch (e) {
      log("로그인 실패", error: e);
      rethrow;
    }
  }

  Future<Me?> _requestLoginWithApple() async {
    try {
      final info = await AppleLoginUtil.signInWithApple();
      return GetIt.I.get<LoginWithAppleUseCase>().call(info);
    } catch (e) {
      log("로그인 실패", error: e);
      rethrow;
    }
  }
}
