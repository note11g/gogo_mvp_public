import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app_version_info.freezed.dart';
part 'app_version_info.g.dart';

@freezed
class AppVersionInfo with _$AppVersionInfo {
  const factory AppVersionInfo({
    required String version,
    @JsonKey(name: 'version_code')
    required int versionCode,
    @JsonKey(name: 'android_update_url')
    required String androidUpdateUrl,
    @JsonKey(name: 'ios_update_url')
    required String iosUpdateUrl,
    @JsonKey(name: 'update_message')
    required String updateMessage,
  }) = _AppVersionInfo;

  factory AppVersionInfo.fromJson(dynamic json) =>
      _$AppVersionInfoFromJson(json);
}