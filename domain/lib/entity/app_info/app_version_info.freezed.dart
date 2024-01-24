// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_version_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AppVersionInfo _$AppVersionInfoFromJson(Map<String, dynamic> json) {
  return _AppVersionInfo.fromJson(json);
}

/// @nodoc
mixin _$AppVersionInfo {
  String get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'version_code')
  int get versionCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'android_update_url')
  String get androidUpdateUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'ios_update_url')
  String get iosUpdateUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'update_message')
  String get updateMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppVersionInfoCopyWith<AppVersionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppVersionInfoCopyWith<$Res> {
  factory $AppVersionInfoCopyWith(
          AppVersionInfo value, $Res Function(AppVersionInfo) then) =
      _$AppVersionInfoCopyWithImpl<$Res, AppVersionInfo>;
  @useResult
  $Res call(
      {String version,
      @JsonKey(name: 'version_code') int versionCode,
      @JsonKey(name: 'android_update_url') String androidUpdateUrl,
      @JsonKey(name: 'ios_update_url') String iosUpdateUrl,
      @JsonKey(name: 'update_message') String updateMessage});
}

/// @nodoc
class _$AppVersionInfoCopyWithImpl<$Res, $Val extends AppVersionInfo>
    implements $AppVersionInfoCopyWith<$Res> {
  _$AppVersionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? versionCode = null,
    Object? androidUpdateUrl = null,
    Object? iosUpdateUrl = null,
    Object? updateMessage = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      versionCode: null == versionCode
          ? _value.versionCode
          : versionCode // ignore: cast_nullable_to_non_nullable
              as int,
      androidUpdateUrl: null == androidUpdateUrl
          ? _value.androidUpdateUrl
          : androidUpdateUrl // ignore: cast_nullable_to_non_nullable
              as String,
      iosUpdateUrl: null == iosUpdateUrl
          ? _value.iosUpdateUrl
          : iosUpdateUrl // ignore: cast_nullable_to_non_nullable
              as String,
      updateMessage: null == updateMessage
          ? _value.updateMessage
          : updateMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppVersionInfoCopyWith<$Res>
    implements $AppVersionInfoCopyWith<$Res> {
  factory _$$_AppVersionInfoCopyWith(
          _$_AppVersionInfo value, $Res Function(_$_AppVersionInfo) then) =
      __$$_AppVersionInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String version,
      @JsonKey(name: 'version_code') int versionCode,
      @JsonKey(name: 'android_update_url') String androidUpdateUrl,
      @JsonKey(name: 'ios_update_url') String iosUpdateUrl,
      @JsonKey(name: 'update_message') String updateMessage});
}

/// @nodoc
class __$$_AppVersionInfoCopyWithImpl<$Res>
    extends _$AppVersionInfoCopyWithImpl<$Res, _$_AppVersionInfo>
    implements _$$_AppVersionInfoCopyWith<$Res> {
  __$$_AppVersionInfoCopyWithImpl(
      _$_AppVersionInfo _value, $Res Function(_$_AppVersionInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? versionCode = null,
    Object? androidUpdateUrl = null,
    Object? iosUpdateUrl = null,
    Object? updateMessage = null,
  }) {
    return _then(_$_AppVersionInfo(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      versionCode: null == versionCode
          ? _value.versionCode
          : versionCode // ignore: cast_nullable_to_non_nullable
              as int,
      androidUpdateUrl: null == androidUpdateUrl
          ? _value.androidUpdateUrl
          : androidUpdateUrl // ignore: cast_nullable_to_non_nullable
              as String,
      iosUpdateUrl: null == iosUpdateUrl
          ? _value.iosUpdateUrl
          : iosUpdateUrl // ignore: cast_nullable_to_non_nullable
              as String,
      updateMessage: null == updateMessage
          ? _value.updateMessage
          : updateMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AppVersionInfo
    with DiagnosticableTreeMixin
    implements _AppVersionInfo {
  const _$_AppVersionInfo(
      {required this.version,
      @JsonKey(name: 'version_code') required this.versionCode,
      @JsonKey(name: 'android_update_url') required this.androidUpdateUrl,
      @JsonKey(name: 'ios_update_url') required this.iosUpdateUrl,
      @JsonKey(name: 'update_message') required this.updateMessage});

  factory _$_AppVersionInfo.fromJson(Map<String, dynamic> json) =>
      _$$_AppVersionInfoFromJson(json);

  @override
  final String version;
  @override
  @JsonKey(name: 'version_code')
  final int versionCode;
  @override
  @JsonKey(name: 'android_update_url')
  final String androidUpdateUrl;
  @override
  @JsonKey(name: 'ios_update_url')
  final String iosUpdateUrl;
  @override
  @JsonKey(name: 'update_message')
  final String updateMessage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppVersionInfo(version: $version, versionCode: $versionCode, androidUpdateUrl: $androidUpdateUrl, iosUpdateUrl: $iosUpdateUrl, updateMessage: $updateMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppVersionInfo'))
      ..add(DiagnosticsProperty('version', version))
      ..add(DiagnosticsProperty('versionCode', versionCode))
      ..add(DiagnosticsProperty('androidUpdateUrl', androidUpdateUrl))
      ..add(DiagnosticsProperty('iosUpdateUrl', iosUpdateUrl))
      ..add(DiagnosticsProperty('updateMessage', updateMessage));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppVersionInfo &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.versionCode, versionCode) ||
                other.versionCode == versionCode) &&
            (identical(other.androidUpdateUrl, androidUpdateUrl) ||
                other.androidUpdateUrl == androidUpdateUrl) &&
            (identical(other.iosUpdateUrl, iosUpdateUrl) ||
                other.iosUpdateUrl == iosUpdateUrl) &&
            (identical(other.updateMessage, updateMessage) ||
                other.updateMessage == updateMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, version, versionCode,
      androidUpdateUrl, iosUpdateUrl, updateMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppVersionInfoCopyWith<_$_AppVersionInfo> get copyWith =>
      __$$_AppVersionInfoCopyWithImpl<_$_AppVersionInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AppVersionInfoToJson(
      this,
    );
  }
}

abstract class _AppVersionInfo implements AppVersionInfo {
  const factory _AppVersionInfo(
      {required final String version,
      @JsonKey(name: 'version_code')
          required final int versionCode,
      @JsonKey(name: 'android_update_url')
          required final String androidUpdateUrl,
      @JsonKey(name: 'ios_update_url')
          required final String iosUpdateUrl,
      @JsonKey(name: 'update_message')
          required final String updateMessage}) = _$_AppVersionInfo;

  factory _AppVersionInfo.fromJson(Map<String, dynamic> json) =
      _$_AppVersionInfo.fromJson;

  @override
  String get version;
  @override
  @JsonKey(name: 'version_code')
  int get versionCode;
  @override
  @JsonKey(name: 'android_update_url')
  String get androidUpdateUrl;
  @override
  @JsonKey(name: 'ios_update_url')
  String get iosUpdateUrl;
  @override
  @JsonKey(name: 'update_message')
  String get updateMessage;
  @override
  @JsonKey(ignore: true)
  _$$_AppVersionInfoCopyWith<_$_AppVersionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
