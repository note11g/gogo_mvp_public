import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gogo_mvp/presentation/src/core/util/photo_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/string_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/toast_util.dart';
import 'package:gogo_mvp/presentation/src/design/color/go_color.dart';
import 'package:gogo_mvp/presentation/src/design/component/components.dart';
import 'package:photo_view/photo_view.dart';

class ChatPhotoView extends StatefulWidget {
  final String url;
  final DateTime timestamp;

  const ChatPhotoView({super.key, required this.url, required this.timestamp});

  @override
  State<ChatPhotoView> createState() => _ChatPhotoViewState();
}

class _ChatPhotoViewState extends State<ChatPhotoView> {
  bool showUi = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GoColors.black,
        body: Stack(children: [
          ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(widget.url),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                onTapUp: (_, __, ___) {
                  setState(() => showUi = !showUi);
                },
              )),
          if (showUi)
            Positioned.fill(
                bottom: null,
                child: Container(
                    color: GoColors.black.withOpacity(0.5),
                    padding:
                        EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GoIconButton(
                              name: "back",
                              size: 24,
                              onTap: context.pop,
                              iconColor: GoColors.white),
                          GoIconButton(
                              name: "download",
                              size: 24,
                              onTap: () => _downloadImage(context),
                              iconColor: GoColors.white),
                        ]))),
        ]));
  }

  void _downloadImage(BuildContext context) async {
    context.openToast("다운로드를 시작합니다.");
    final extension = widget.url.contains(".heic")
        ? ".heic"
        : widget.url.contains("webp")
            ? ".webp"
            : ".jpg";
    final fileName =
        "gogo-chat-${widget.timestamp.toDateTimeStringWithDash()}$extension";
    await PhotoUtil.downloadAndSaveImage(widget.url, fileName: fileName);
    if (context.mounted) context.openToast("다운로드가 완료되었습니다.");
  }
}
