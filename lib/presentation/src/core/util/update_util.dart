import 'dart:io';

import 'package:gogo_mvp_domain/entity/app_info/app_version_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateUtil {
  static Future<void> checkNeedUpdate({
    required Future<AppVersionInfo> Function() getVersionInfo,
    required void Function(AppVersionInfo info) onNeedUpdate,
  }) async {
    final versionInfo = await getVersionInfo();
    if (await _needUpdate(latestVersionCode: versionInfo.versionCode)) {
      onNeedUpdate(versionInfo);
    }
  }

  static Future<bool> _needUpdate({required int latestVersionCode}) async {
    final nowVersionCode =
        await _getNowVersionCode().then((code) => int.parse(code));
    return nowVersionCode < latestVersionCode;
  }

  static Future<String> _getNowVersionCode() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  static Future<void> openUpdateUrl(AppVersionInfo versionInfo) async {
    final url = Platform.isAndroid
        ? versionInfo.androidUpdateUrl
        : versionInfo.iosUpdateUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Can't launch $url");
    }
  }

  UpdateUtil._();
}
