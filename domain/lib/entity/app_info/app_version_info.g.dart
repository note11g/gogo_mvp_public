// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppVersionInfo _$$_AppVersionInfoFromJson(Map<String, dynamic> json) =>
    _$_AppVersionInfo(
      version: json['version'] as String,
      versionCode: json['version_code'] as int,
      androidUpdateUrl: json['android_update_url'] as String,
      iosUpdateUrl: json['ios_update_url'] as String,
      updateMessage: json['update_message'] as String,
    );

Map<String, dynamic> _$$_AppVersionInfoToJson(_$_AppVersionInfo instance) =>
    <String, dynamic>{
      'version': instance.version,
      'version_code': instance.versionCode,
      'android_update_url': instance.androidUpdateUrl,
      'ios_update_url': instance.iosUpdateUrl,
      'update_message': instance.updateMessage,
    };
