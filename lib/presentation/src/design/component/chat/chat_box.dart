part of go_design_component;

enum ChatMessageType { text, image }

class GoChatBox extends StatelessWidget {
  final ChatMessage item;
  final bool needTopMerge;
  final bool needBottomMerge;
  final Me me;
  final User owner;

  /// already read, onDoubleTap disabled.
  final void Function()? onFullDoubleTapWhenNotReadAndNotMeAndNotBottomMerge;
  final void Function()? onReadBadgeTap;
  final void Function(ChatMessageType type, bool canRead)? onChatLongPress;
  final void Function(String url)? onLinkTap;
  final void Function(String url)? onImageTap;

  const GoChatBox({
    super.key,
    required this.item,
    required this.needTopMerge,
    required this.needBottomMerge,
    required this.me,
    required this.owner,
    this.onFullDoubleTapWhenNotReadAndNotMeAndNotBottomMerge,
    this.onReadBadgeTap,
    this.onChatLongPress,
    this.onLinkTap,
    this.onImageTap,
  });

  bool get isMine => item.user.id == me.id;

  bool get isMyRead => item.readUsers.map((user) => user.id).contains(me.id);

  bool get isOwnerMsg => item.user == owner;

  bool get canRead => !(isMyRead || isMine || needBottomMerge);

  // bool get isImage => RegExp(r"\[image:[^\]]+\]").hasMatch(item.message);

  bool get isFirebaseStorageImage => RegExp(
          r"\[image:https://firebasestorage.googleapis.com/v0/[a-z]/gogo-mvp.appspot.com/o/chat%2F[^?]+\?alt=media&token=[^\]]+\]")
      .hasMatch(item.message);

  @override
  Widget build(BuildContext context) {
    final rowChildrenWidgets = [
      _messageBox(context),
      _timeWidget(item.time),
    ];

    final chatAndTimeWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children:
            isMine ? rowChildrenWidgets.reversed.toList() : rowChildrenWidgets);

    final chatAndTimeAndProfileWidget = isMine || needTopMerge
        ? chatAndTimeWidget
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_nameWidget(), chatAndTimeWidget]);

    final chatWidgetAddedBadgeWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap:
          canRead ? onFullDoubleTapWhenNotReadAndNotMeAndNotBottomMerge : null,
      child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            chatAndTimeAndProfileWidget,
            if (!needBottomMerge)
              _chatCheckBadge(showReadGuide: !isMine && !isMyRead),
          ]),
    );

    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8)
            .copyWith(bottom: 4, top: needTopMerge ? 0 : null),
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isMine && !needTopMerge) _profileImageWidget(),
              if (needTopMerge) const GoSpacer(44, axis: Axis.horizontal),
              chatWidgetAddedBadgeWidget,
            ]));
  }

  Widget _messageBox(BuildContext context) => GestureDetector(
        onLongPress: () => onChatLongPress?.call(
            isFirebaseStorageImage
                ? ChatMessageType.image
                : ChatMessageType.text,
            canRead),
        onTap: isFirebaseStorageImage
            ? () => onImageTap?.call(_parseImageUrl(item.message))
            : null,
        child: Container(
            constraints: BoxConstraints(maxWidth: _getChatBoxMaxWidth(context)),
            decoration: BoxDecoration(
              color: isMine ? GoColors.primaryOrange : GoColors.white,
              borderRadius: GoRounds.m.borderRadius,
            ),
            padding: !isFirebaseStorageImage
                ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12)
                : null,
            child: !isFirebaseStorageImage
                ? _messageTextWidget(item.message)
                : _messageImageWidget(item.message)),
      );

  Widget _messageTextWidget(String text) => LinkifyText(
        text,
        linkTypes: const [LinkType.url],
        textStyle: GoTypos.chatMessageText(
            color: isMine ? GoColors.white : Colors.black),
        linkStyle: GoTypos.chatMessageText(color: GoColors.linkBlue),
        onTap: (link) => onLinkTap?.call(link.value ?? ""),
      );

  Widget _messageImageWidget(String rawText) {
    final url = _parseImageUrl(rawText);
    return Container(
        constraints: const BoxConstraints(maxHeight: 260),
        child: ClipRRect(
            borderRadius: GoRounds.m.borderRadius,
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => const SizedBox(height: 120),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fadeInDuration: Duration.zero,
              fit: BoxFit.cover,
            )));
  }

  String _parseImageUrl(String rawText) {
    return rawText.replaceAll("[image:", "").replaceAll("]", "");
  }

  Widget _timeWidget(DateTime time) => Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 2),
        child: Text(time.toTimeString(), style: GoTypos.chatDescriptionText()),
      );

  Widget _nameWidget() => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(
            item.user.somaRole == SomaRole.trainee
                ? item.user.name
                : "${item.user.name} (${item.user.somaRole.kor})",
            style: GoTypos.chatDescriptionText(color: GoColors.black)),
        if (isOwnerMsg)
          const Padding(
            padding: EdgeInsets.only(left: 2),
            child:
                GoIcon(name: "owner", size: 14, color: GoColors.primaryOrange),
          ),
      ]));

  Widget _chatCheckBadge({bool showReadGuide = false}) {
    final readCount = item.readUsers.length;
    return GestureDetector(
      onTap: onReadBadgeTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: readCount != 0
                    ? GoColors.validGreen
                    : GoColors.disabledGray,
                borderRadius: GoRounds.circle.borderRadius,
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const GoIcon(name: "check", size: 10),
                const GoSpacer(6),
                Text("$readCount명 확인",
                    style: GoTypos.chatDescriptionText(color: GoColors.white)),
                const GoIcon(name: "arrow_right", size: 8),
              ])),
          if (showReadGuide)
            Padding(
                padding: const EdgeInsets.only(left: 6),
                child: AnimatedTextKit(
                    repeatForever: true,
                    pause: Duration.zero,
                    animatedTexts: [
                      FadeAnimatedText("확인했다면, 두번 탭해주세요!",
                          duration: const Duration(milliseconds: 1600),
                          textStyle: GoTypos.chatDescriptionText()),
                    ])),
        ]),
      ),
    );
  }

  Widget _profileImageWidget() => Padding(
        padding: const EdgeInsets.only(right: 8, top: 2),
        child: ProfilePhotoView(image: item.user.profileImageUrl, size: 36),
      );

  double _getChatBoxMaxWidth(context) =>
      MediaQuery.sizeOf(context).width * 0.6;
}
