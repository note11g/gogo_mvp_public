// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Me _$MeFromJson(Map<String, dynamic> json) {
  return _Me.fromJson(json);
}

/// @nodoc
mixin _$Me {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  SomaRole get somaRole => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeCopyWith<Me> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeCopyWith<$Res> {
  factory $MeCopyWith(Me value, $Res Function(Me) then) =
      _$MeCopyWithImpl<$Res, Me>;
  @useResult
  $Res call(
      {String id,
      String name,
      String profileImageUrl,
      String email,
      SomaRole somaRole,
      List<String> tags});
}

/// @nodoc
class _$MeCopyWithImpl<$Res, $Val extends Me> implements $MeCopyWith<$Res> {
  _$MeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImageUrl = null,
    Object? email = null,
    Object? somaRole = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      somaRole: null == somaRole
          ? _value.somaRole
          : somaRole // ignore: cast_nullable_to_non_nullable
              as SomaRole,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MeCopyWith<$Res> implements $MeCopyWith<$Res> {
  factory _$$_MeCopyWith(_$_Me value, $Res Function(_$_Me) then) =
      __$$_MeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String profileImageUrl,
      String email,
      SomaRole somaRole,
      List<String> tags});
}

/// @nodoc
class __$$_MeCopyWithImpl<$Res> extends _$MeCopyWithImpl<$Res, _$_Me>
    implements _$$_MeCopyWith<$Res> {
  __$$_MeCopyWithImpl(_$_Me _value, $Res Function(_$_Me) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImageUrl = null,
    Object? email = null,
    Object? somaRole = null,
    Object? tags = null,
  }) {
    return _then(_$_Me(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      somaRole: null == somaRole
          ? _value.somaRole
          : somaRole // ignore: cast_nullable_to_non_nullable
              as SomaRole,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Me extends _Me with DiagnosticableTreeMixin {
  const _$_Me(
      {required this.id,
      required this.name,
      required this.profileImageUrl,
      required this.email,
      required this.somaRole,
      required final List<String> tags})
      : _tags = tags,
        super._();

  factory _$_Me.fromJson(Map<String, dynamic> json) => _$$_MeFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String profileImageUrl;
  @override
  final String email;
  @override
  final SomaRole somaRole;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Me(id: $id, name: $name, profileImageUrl: $profileImageUrl, email: $email, somaRole: $somaRole, tags: $tags)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Me'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('profileImageUrl', profileImageUrl))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('somaRole', somaRole))
      ..add(DiagnosticsProperty('tags', tags));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Me &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.somaRole, somaRole) ||
                other.somaRole == somaRole) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, profileImageUrl, email,
      somaRole, const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MeCopyWith<_$_Me> get copyWith =>
      __$$_MeCopyWithImpl<_$_Me>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MeToJson(
      this,
    );
  }
}

abstract class _Me extends Me {
  const factory _Me(
      {required final String id,
      required final String name,
      required final String profileImageUrl,
      required final String email,
      required final SomaRole somaRole,
      required final List<String> tags}) = _$_Me;
  const _Me._() : super._();

  factory _Me.fromJson(Map<String, dynamic> json) = _$_Me.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get profileImageUrl;
  @override
  String get email;
  @override
  SomaRole get somaRole;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$_MeCopyWith<_$_Me> get copyWith => throw _privateConstructorUsedError;
}
