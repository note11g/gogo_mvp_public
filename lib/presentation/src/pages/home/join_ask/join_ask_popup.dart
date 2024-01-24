import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gogo_mvp/presentation/presentation.dart';
import 'package:gogo_mvp/presentation/src/core/routing/dialog_navigator_page.dart';
import 'package:gogo_mvp/presentation/src/core/util/loading_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/toast_util.dart';
import 'package:gogo_mvp/presentation/src/pages/home/join_ask/join_ask_popup_view_model.dart';
import 'package:view_model_kit/view_model_kit.dart';

import '../../../design/color/go_color.dart';
import '../../../design/component/components.dart';
import '../../../design/typo/typo.dart';

class JoinAskPopUpPage extends DialogPage {
  JoinAskPopUpPage({
    required String id,
    required bool isLinkInvite,
  }) : super(
            builder: (context) => JoinAskPopup(
                  gogoId: id,
                  isLinkInvite: isLinkInvite,
                ));
}

class JoinAskPopup extends StatefulWidget {
  final String gogoId;
  final bool isLinkInvite;

  const JoinAskPopup(
      {super.key, required this.gogoId, required this.isLinkInvite});

  @override
  State<JoinAskPopup> createState() => _JoinAskPopupState();
}

class _JoinAskPopupState
    extends StateWithViewModel<JoinAskPopup, JoinAskPopupViewModel> {
  @override
  JoinAskPopupViewModel createViewModel() => JoinAskPopupViewModel(
        gogoId: widget.gogoId,
        isLinkInvite: widget.isLinkInvite,
        onFindFailed: onFindFailed,
        onAlreadyJoined: onAlreadyJoined,
      );

  void onFindFailed() {
    context.pop();
    context.openToast("마감되었거나 존재하지 않는\nㄱㄱ? 초대입니다.");
  }

  void onAlreadyJoined() {
    void fn() {
      context.pop();
      final targetRoute = GoPages.chat(id: widget.gogoId);
      if (GetIt.I.get<GoGoRouteHelper>().nowLocation != targetRoute) {
        context.push(targetRoute);
      }
    }

    if (buildRunning) {
      WidgetsBinding.instance.addPostFrameCallback((_) => fn());
    } else {
      fn();
    }
  }

  Widget _loadingIndicator() => const Center(
      child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(GoColors.white))));

  bool buildRunning = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      buildRunning = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildRunning = true;
    if (viewModel.info.value == null) return _loadingIndicator();
    return GoDialog(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.fromLTRB(20, 24, 0, 20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerSection(),
              const GoSpacer(24),
              _profileSection(),
              const GoSpacer(24),
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _buttonSection()),
            ]));
  }

  Widget _headerSection() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text.rich(TextSpan(children: [
          TextSpan(
              text: viewModel.info.value!.tag, style: GoTypos.tagAtAskJoin()),
          TextSpan(text: "팟", style: GoTypos.tagAtAskJoin(color: Colors.black)),
        ])),
        const GoSpacer(6),
        Text(viewModel.info.value!.title, style: GoTypos.titleAtAskJoin()),
      ]);

  Widget _profileSection() =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text("참여한 사람 (${viewModel.info.value!.users.length}명)",
            style: GoTypos.subTitleAtAskJoin()),
        const GoSpacer(12),
        MultiMiniProfilesView(
            profileViews: viewModel.info.value!.users
                .map((user) => MiniProfileView(
                    name: user.name,
                    profileUrl: user.profileImageUrl,
                    isOwner: user.id == viewModel.info.value!.owner.id))
                .toList()),
      ]);

  Widget _buttonSection() => Row(children: [
        Expanded(
            child: HalfCTAButton("ㅠㅠ 다음에..", secondary: true, onTap: () {
          _deleteNotification();
          context.load(viewModel.denyInvite).then((_) => context.pop());
        })),
        const GoSpacer(8),
        Expanded(
            child: HalfCTAButton("ㄱㄱ!", onTap: () {
          _deleteNotification();
          context.load(viewModel.acceptInvite).then((_) => context
              .pushReplacement(GoPages.chat(id: viewModel.info.value!.id)));
        })),
      ]);

  void _deleteNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final activeNotifications =
        await flutterLocalNotificationsPlugin.getActiveNotifications();
    for (final notification in activeNotifications) {
      if (Platform.isAndroid) {
        final isSameGogo = notification.tag == widget.gogoId;
        if (isSameGogo) {
          await flutterLocalNotificationsPlugin.cancel(notification.id!,
              tag: notification.tag!);
          break;
        }
      } else {
        final gogo = viewModel.info.value!;
        final isSameGogo = notification.title == gogo.title &&
            notification.body?.contains(gogo.owner.name) == true &&
            notification.body?.contains(gogo.tag) == true;

        if (isSameGogo) {
          /// iOS는 Flutter-Local-Notification 패키지는 id를 가져올 수 없음.
          /// 따라서, 알림을 모두 지워버림.
          /// 이후에, 패키지를 수정하여 id를 가져올 수 있도록 수정해야 함.
          await flutterLocalNotificationsPlugin.cancelAll();
          break;
        }
      }
    }
  }
}
