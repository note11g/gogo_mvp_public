import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:gogo_mvp/analytics/amplitude_util.dart';
import 'package:gogo_mvp/presentation/src/core/routing/routing.dart';
import 'package:gogo_mvp/presentation/src/core/util/loading_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/photo_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/toast_util.dart';
import 'package:gogo_mvp/presentation/src/design/color/go_color.dart';
import 'package:gogo_mvp/presentation/src/design/component/components.dart';
import 'package:gogo_mvp/presentation/src/design/round/round.dart';
import 'package:gogo_mvp/presentation/src/design/typo/typo.dart';
import 'package:gogo_mvp/presentation/src/core/util/string_util.dart';
import 'package:gogo_mvp/presentation/src/pages/chat/chat_photo_view.dart';
import 'package:gogo_mvp/presentation/src/pages/chat/chat_view_model.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_items.dart';
import 'package:gogo_mvp_domain/entity/user/user.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:view_model_kit/view_model_kit.dart';

class ChatPage extends StatefulWidget {
  final String id;

  const ChatPage({super.key, required this.id});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends StateWithViewModel<ChatPage, ChatViewModel> {
  final _key = GlobalKey<ScaffoldState>();
  final _messageFieldController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  ChatViewModel createViewModel() =>
      ChatViewModel(widget.id, onNotFoundGogoInfo: _onNotFoundGogoInfo);

  void _onNotFoundGogoInfo() {
    context.openToast("존재하지 않는 ㄱㄱ입니다.");
    context.go(GoPages.home);
  }

  @override
  void initState() {
    viewModel.textFieldMessage.observe((message) {
      if (_messageFieldController.text != message) {
        _messageFieldController.text = message;
      }
    });
    AmplitudeUtil.track("chat_page", action: UserAction.enter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldFocusOutHelper(
      child: Scaffold(
          key: _key,
          endDrawer: _drawer(context),
          endDrawerEnableOpenDragGesture: Platform.isIOS,
          backgroundColor: GoColors.backgroundGray,
          body: Stack(children: [
            Column(children: [
              _appBar(context),
              Expanded(child: _chatListSection(context)),
              _chatField(context),
            ]),
            FullScreenLoadingIndicator(
                isLoading: viewModel.gogoInfo.value == null),
          ])),
    );
  }

  void _openDrawer() => _key.currentState?.openEndDrawer();

  Widget _chatListSection(BuildContext context) => ListView.builder(
      controller: _scrollController,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: viewModel.chatItems.length,
      itemBuilder: (context, index) {
        final items = viewModel.chatItems;

        return _chatItemWidget(items[index],
            oldItem: index != items.length - 1 ? items[index + 1] : null,
            nextItem: index != 0 ? items[index - 1] : null);
      });

  Widget _chatItemWidget(ChatItem item,
      {required ChatItem? oldItem, required ChatItem? nextItem}) {
    return switch (item) {
      ChatMessage() =>
        _createGoChatBox(item, oldItem: oldItem, nextItem: nextItem),
      ChatDate() => ChatDateItem(date: item),
      ChatEnterOrLeaveRecord() => ChatRoomEnterOrLeaveBox(record: item),
    };
  }

  GoChatBox _createGoChatBox(ChatMessage item,
      {required ChatItem? oldItem, required ChatItem? nextItem}) {
    final needTopMerge = oldItem is ChatMessage &&
        oldItem.user.id == item.user.id &&
        oldItem.readUsers.isEmpty; // 위의 채팅이랑 합치는 경우

    final needBottomMerge = nextItem is ChatMessage &&
        nextItem.user.id == item.user.id &&
        item.readUsers.isEmpty; // 아래의 채팅이랑 합치는 경우

    return GoChatBox(
      item: item,
      needTopMerge: needTopMerge,
      needBottomMerge: needBottomMerge,
      me: viewModel.me.value!,
      owner: viewModel.gogoInfo.value!.owner,
      onFullDoubleTapWhenNotReadAndNotMeAndNotBottomMerge: () =>
          viewModel.readMessage(messageId: item.id),
      onReadBadgeTap: () => _openReadPersonBottomSheet(item.readUsers),
      onChatLongPress: (type, canRead) =>
          _onLongPressMessage(item, type, canRead),
      onLinkTap: _openLink,
      onImageTap: (url) => _openImageViewer(url, item.time),
    );
  }

  Widget _chatField(BuildContext context) => Container(
      color: GoColors.white,
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        GoIconButton(name: "pic", size: 24, onTap: _selectImage),
        Expanded(
            child: TextFieldTypeC(
          hint: "메세지를 입력하세요",
          controller: _messageFieldController,
          onChanged: (str) => viewModel.textFieldMessage.value = str,
        )),
        SelectBuilder(
            rx: viewModel.textFieldMessage,
            builder: (context, message) => GoIconButton(
                name: "send",
                size: 24,
                enabled: message.isNotEmpty,
                disabledIconColor: GoColors.disabledGray,
                onTap: () {
                  viewModel.sendMessage();
                  _scrollController.jumpTo(0);
                })),
      ])));

  Material _appBar(BuildContext context) {
    final screenPadding = MediaQuery.paddingOf(context);

    final backButton = GoIconButton(
        name: "back", size: 24, onTap: context.pop, iconColor: GoColors.black);

    final menuButton = GoIconButton(
        name: "menu", size: 24, onTap: _openDrawer, iconColor: GoColors.black);

    final gogoInfo = viewModel.gogoInfo.value;

    final centerInfo = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const GoSpacer(2),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(gogoInfo?.title ?? "", style: GoTypos.appBarTitleAtChat()),
            const GoSpacer(2),
            Text(gogoInfo?.tag ?? "", style: GoTypos.appBarTagAtChat()),
          ]),
          const GoSpacer(4),
          Text(
              gogoInfo != null && viewModel.users.isNotEmpty
                  ? "${viewModel.users.first.name.appendGwaAndWa} "
                      "${viewModel.users.length - 1}명이 함께하는 중 (총 ${viewModel.users.length}명)"
                  : "",
              style: GoTypos.appBarDescriptionAtChat()),
        ]);

    return Material(
        color: GoColors.white,
        child: Padding(
            padding: EdgeInsets.only(top: 4 + screenPadding.top, bottom: 4),
            child: Stack(children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    backButton,
                    menuButton,
                  ]),
              Positioned.fill(child: centerInfo)
            ])));
  }

  Drawer _drawer(BuildContext context) {
    final screenPadding = MediaQuery.paddingOf(context);
    final gogoInfo = viewModel.gogoInfo.value;

    final titleSection = Container(
        width: double.infinity,
        color: GoColors.white,
        padding: EdgeInsets.fromLTRB(16, 72 + screenPadding.top, 16, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(gogoInfo?.tag ?? "", style: GoTypos.drawerTagAtChat()),
          const GoSpacer(6),
          Text(gogoInfo?.title ?? "", style: GoTypos.drawerTitleAtChat()),
          const GoSpacer(6),
          Text(
              gogoInfo != null
                  ? "${gogoInfo.owner.name.appendLeeAndGa} "
                      "${gogoInfo.createdAt.toDateString(dayOfWeek: false, full: false)}에 만듦"
                  : "",
              style: GoTypos.drawerDescriptionAtChat()),
          const GoSpacer(4),
          LinkButton("ㄱㄱ 공유하기",
              padding: const EdgeInsets.symmetric(vertical: 8),
              onTap: _shareInviteLink),
        ]));

    final nameSection = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("참여한 사람 (${viewModel.users.length}명)",
                  style: GoTypos.drawerSubTitleAtChat()),
              const GoSpacer(8),
              ...viewModel.users.value
                  .map((user) => MiniProfileView(
                        name: user.name,
                        profileUrl: user.profileImageUrl,
                        isOwner: user.id == gogoInfo?.owner.id,
                      ))
                  .toList(),
            ]));

    final bottomSection = RawButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: EdgeInsets.only(bottom: screenPadding.bottom + 8),
        onTap: () => showDialog(
            context: context,
            builder: (_) => _OneMoreAskLeaveDialog(
                onLeave: (context) =>
                    context.load(viewModel.leaveGogo).then((_) {
                      context.go(GoPages.home);
                      context.openToast("모임에서 나왔어요.");
                    }),
                onCancel: (context) => context.pop())),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const GoIcon(
                  name: "leave", size: 20, color: GoColors.secondaryGray),
              const GoSpacer(8),
              Text("나가기", style: GoTypos.drawerDescriptionAtChat()),
            ]));

    return Drawer(
        elevation: 4,
        backgroundColor: GoColors.backgroundGray,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          titleSection,
          nameSection,
          const Spacer(),
          bottomSection,
        ]));
  }

  void _openBottomSheet(BuildContext context, {required Widget child}) =>
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: GoRounds.l.radius)),
          builder: (context) {
            final screenPadding = MediaQuery.paddingOf(context);
            return Padding(
                padding: EdgeInsets.only(bottom: screenPadding.bottom),
                child: child);
          });

  void _openReadPersonBottomSheet(List<User> readUsers) {
    final owner = viewModel.gogoInfo.value!.owner;
    _openBottomSheet(context,
        child: _ReadPersonBottomSheet(readUsers: readUsers, owner: owner));
  }

  void _onLongPressMessage(
      ChatMessage message, ChatMessageType type, bool canRead) {
    HapticFeedback.heavyImpact();
    showDialog(
        context: context,
        builder: (context) => _ChatMessageMenuDialog(
              message.message,
              type: type,
              canRead: canRead,
              isMine: viewModel.me.value?.id == message.user.id,
              readMessageFunction: () =>
                  viewModel.readMessage(messageId: message.id),
              reportMessageFunction: (reportMessage) => viewModel.reportMessage(
                  messageId: message.id, reportMessage: reportMessage),
            ));
  }

  void _openLink(String link) async {
    Uri uri = Uri.parse(link);
    if (uri.scheme.isEmpty) uri = Uri.parse("https://$link");

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $link');
    }
  }

  void _openImageViewer(String url, DateTime time) {
    final createdRoute = MaterialPageRoute(
        builder: (context) => ChatPhotoView(url: url, timestamp: time));
    Navigator.push(context, createdRoute);
  }

  void _selectImage() async {
    try {
      final compressedImage = await context.load(
          () => PhotoUtil.pickImageFromGalleryAndCompressImage(
              format: Platform.isAndroid
                  ? CompressFormat.jpeg
                  : CompressFormat.heic,
              minSize: 3000,
              compressQuality: 30),
          errorToast: false);
      if (compressedImage == null) return;
      if (context.mounted) {
        context.load(() => viewModel.sendImage(compressedImage));
      } else {
        context.openToast("이미지 전송을 취소했어요.");
      }
    } on PhotoUtilException catch (e) {
      context.openToast(e.message);
    }
  }

  void _shareInviteLink() async {
    final inviteLink = _createInviteLink();
    await Share.shareUri(inviteLink);
  }

  Uri _createInviteLink() {
    final payloadLink = "https://space-traveler-team.github.io/Gogo-Soma"
        "?link_type=invite&inv_code=${widget.id}";
    final inviteLink =
        "https://gogosoma.page.link/?link=${Uri.encodeComponent(payloadLink)}&apn=io.spacet.gogo.gogo_mvp&isi=6451095433&ibi=io.spacet.gogo.gogoSoma";
    return Uri.parse(inviteLink);
  }
}

class _ReadPersonBottomSheet extends StatelessWidget {
  final List<User> readUsers;
  final User owner;

  const _ReadPersonBottomSheet({required this.readUsers, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("확인한 사람 (${readUsers.length}명)",
                        style: GoTypos.bottomSheetTitleAtChat()),
                    GoIconButton(
                        name: "close",
                        size: 24,
                        onTap: context.pop,
                        padding: const EdgeInsets.all(4)),
                  ]),
              const GoSpacer(16),
              MultiMiniProfilesView(
                  rowCount: 2,
                  profileViews: readUsers
                      .map((user) => MiniProfileView(
                            name: user.name,
                            profileUrl: user.profileImageUrl,
                            isOwner: user == owner,
                          ))
                      .toList())
            ]));
  }
}

class _OneMoreAskLeaveDialog extends StatelessWidget {
  final void Function(BuildContext context) onLeave;
  final void Function(BuildContext context) onCancel;

  const _OneMoreAskLeaveDialog({
    required this.onLeave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GoDialog(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text("모임 나가기", style: GoTypos.updateDialogTitle()),
          const GoSpacer(16),
          Text("정말로 나가시겠어요?\n한번 나간 모임은 초대를 통해서만 다시 참여할 수 있어요.",
              style: GoTypos.updateDialogDescription()),
          const GoSpacer(20),
          Row(children: [
            Expanded(
                child: HalfCTAButton("취소",
                    onTap: () => onCancel(context), secondary: false)),
            const GoSpacer(8),
            Expanded(
                child: HalfCTAButton("나가기",
                    onTap: () => onLeave(context), secondary: true)),
          ])
        ]));
  }
}

class _ChatMessageMenuDialog extends StatelessWidget {
  final String text;
  final ChatMessageType type;
  final bool canRead;
  final bool isMine;
  final void Function() readMessageFunction;
  final void Function(String reportMessage) reportMessageFunction;

  const _ChatMessageMenuDialog(
    this.text, {
    required this.type,
    required this.canRead,
    required this.isMine,
    required this.readMessageFunction,
    required this.reportMessageFunction,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      if (type == ChatMessageType.text)
        _menuItem("복사", () => _copyAtClipboard(text, context)),
      if (canRead) _menuItem("읽음으로 표시하기", () => _readMessage(context)),
      if (!isMine) _menuItem("신고하기", () => _openReportDialog(context)),
    ];

    return GoDialog(
        padding: EdgeInsets.zero,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items));
  }

  Widget _menuItem(String title, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(title,
                style: GoTypos.updateDialogDescription(),
                textAlign: TextAlign.center)));
  }

  void _copyAtClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text))
        .then((value) => context.openToast("메세지가 복사되었어요!", seconds: 5));
    context.pop();
  }

  void _readMessage(BuildContext context) {
    readMessageFunction();
    context.pop();
  }

  void _openReportDialog(BuildContext context) {
    context.pop();
    showDialog(
        context: context,
        builder: (context) =>
            _ReportDialog(reportMessageFunction: reportMessageFunction));
  }
}

class _ReportDialog extends StatefulWidget {
  final void Function(String reportMessage) reportMessageFunction;

  const _ReportDialog({required this.reportMessageFunction});

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  String reportMessage = "";

  @override
  Widget build(BuildContext context) {
    return GoDialog(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text("신고하기", style: GoTypos.updateDialogTitle()),
          const GoSpacer(16),
          Text("신고 사유를 입력해주세요. (10자 이상)\n신고는 접수 24시간 이내에 처리됩니다.",
              style: GoTypos.updateDialogDescription()),
          const GoSpacer(12),
          BaseTextField(
              onChange: (value) => setState(() => reportMessage = value),
              textStyle: GoTypos.inputTextAtChat,
              hint: "신고 사유를 입력해주세요.",
              hintColor: GoColors.disabledGray,
              padding: const EdgeInsets.all(12),
              maxLine: 3,
              maxLength: 100,
              backgroundColor: GoColors.dividerGray),
          const GoSpacer(16),
          Row(children: [
            Expanded(
                child: HalfCTAButton("취소",
                    onTap: () => context.pop(), secondary: true)),
            const GoSpacer(8),
            Expanded(
                child: HalfCTAButton("신고하기", onTap: () {
              if (reportMessage.length < 10) {
                context.openToast("신고 사유를 10자 이상 입력해주세요.");
                return;
              }
              widget.reportMessageFunction(reportMessage);
              context.pop();
            }, secondary: false)),
          ])
        ]));
  }
}
