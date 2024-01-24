import 'package:flutter/material.dart';
import 'package:gogo_mvp/presentation/src/core/routing/dialog_navigator_page.dart';
import 'package:gogo_mvp/presentation/src/core/util/update_util.dart';
import 'package:gogo_mvp/presentation/src/design/component/components.dart';
import 'package:gogo_mvp/presentation/src/design/typo/typo.dart';
import 'package:gogo_mvp_domain/entity/app_info/app_version_info.dart';

class NeedUpdatePopUpPage extends DialogPage {
  NeedUpdatePopUpPage({required AppVersionInfo info})
      : super(
            builder: (context) => NeedUpdatePopUp(appVersionInfo: info),
            barrierDismissible: false);
}

class NeedUpdatePopUp extends StatelessWidget {
  final AppVersionInfo appVersionInfo;

  const NeedUpdatePopUp({super.key, required this.appVersionInfo});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GoDialog(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("앱의 새로운 버전이 나왔어요!", style: GoTypos.updateDialogTitle()),
                const GoSpacer(16),
                Text(appVersionInfo.updateMessage.replaceAll("\\n", "\n"),
                    style: GoTypos.updateDialogDescription()),
                const GoSpacer(20),
                FullCTAButton("바로 업데이트 하기",
                    margin: EdgeInsets.zero,
                    onTap: () => UpdateUtil.openUpdateUrl(appVersionInfo)),
              ])),
    );
  }
}
