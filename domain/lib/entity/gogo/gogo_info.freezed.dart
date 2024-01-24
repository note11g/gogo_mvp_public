// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gogo_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GogoInfo _$GogoInfoFromJson(Map<String, dynamic> json) {
  return _GogoInfo.fromJson(json);
}

/// @nodoc
mixin _$GogoInfo {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get tag => throw _privateConstructorUsedError;
  User get owner => throw _privateConstructorUsedError;
  List<User> get users => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get public => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GogoInfoCopyWith<GogoInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GogoInfoCopyWith<$Res> {
  factory $GogoInfoCopyWith(GogoInfo value, $Res Function(GogoInfo) then) =
      _$GogoInfoCopyWithImpl<$Res, GogoInfo>;
  @useResult
  $Res call(
      {String id,
      String title,
      String tag,
      User owner,
      List<User> users,
      DateTime createdAt,
      bool public});

  $UserCopyWith<$Res> get owner;
}

/// @nodoc
class _$GogoInfoCopyWithImpl<$Res, $Val extends GogoInfo>
    implements $GogoInfoCopyWith<$Res> {
  _$GogoInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tag = null,
    Object? owner = null,
    Object? users = null,
    Object? createdAt = null,
    Object? public = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as User,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<User>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      public: null == public
          ? _value.public
          : public // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get owner {
    return $UserCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_GogoInfoCopyWith<$Res> implements $GogoInfoCopyWith<$Res> {
  factory _$$_GogoInfoCopyWith(
          _$_GogoInfo value, $Res Function(_$_GogoInfo) then) =
      __$$_GogoInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String tag,
      User owner,
      List<User> users,
      DateTime createdAt,
      bool public});

  @override
  $UserCopyWith<$Res> get owner;
}

/// @nodoc
class __$$_GogoInfoCopyWithImpl<$Res>
    extends _$GogoInfoCopyWithImpl<$Res, _$_GogoInfo>
    implements _$$_GogoInfoCopyWith<$Res> {
  __$$_GogoInfoCopyWithImpl(
      _$_GogoInfo _value, $Res Function(_$_GogoInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tag = null,
    Object? owner = null,
    Object? users = null,
    Object? createdAt = null,
    Object? public = null,
  }) {
    return _then(_$_GogoInfo(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as User,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<User>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      public: null == public
          ? _value.public
          : public // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GogoInfo with DiagnosticableTreeMixin implements _GogoInfo {
  const _$_GogoInfo(
      {required this.id,
      required this.title,
      required this.tag,
      required this.owner,
      required final List<User> users,
      required this.createdAt,
      required this.public})
      : _users = users;

  factory _$_GogoInfo.fromJson(Map<String, dynamic> json) =>
      _$$_GogoInfoFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String tag;
  @override
  final User owner;
  final List<User> _users;
  @override
  List<User> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  final DateTime createdAt;
  @override
  final bool public;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GogoInfo(id: $id, title: $title, tag: $tag, owner: $owner, users: $users, createdAt: $createdAt, public: $public)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GogoInfo'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('tag', tag))
      ..add(DiagnosticsProperty('owner', owner))
      ..add(DiagnosticsProperty('users', users))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('public', public));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GogoInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.public, public) || other.public == public));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, tag, owner,
      const DeepCollectionEquality().hash(_users), createdAt, public);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GogoInfoCopyWith<_$_GogoInfo> get copyWith =>
      __$$_GogoInfoCopyWithImpl<_$_GogoInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GogoInfoToJson(
      this,
    );
  }
}

abstract class _GogoInfo implements GogoInfo {
  const factory _GogoInfo(
      {required final String id,
      required final String title,
      required final String tag,
      required final User owner,
      required final List<User> users,
      required final DateTime createdAt,
      required final bool public}) = _$_GogoInfo;

  factory _GogoInfo.fromJson(Map<String, dynamic> json) = _$_GogoInfo.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get tag;
  @override
  User get owner;
  @override
  List<User> get users;
  @override
  DateTime get createdAt;
  @override
  bool get public;
  @override
  @JsonKey(ignore: true)
  _$$_GogoInfoCopyWith<_$_GogoInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
