// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gogo_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GogoInfo _$$_GogoInfoFromJson(Map<String, dynamic> json) => _$_GogoInfo(
      id: json['id'] as String,
      title: json['title'] as String,
      tag: json['tag'] as String,
      owner: User.fromJson(json['owner']),
      users: (json['users'] as List<dynamic>).map(User.fromJson).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      public: json['public'] as bool,
    );

Map<String, dynamic> _$$_GogoInfoToJson(_$_GogoInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'tag': instance.tag,
      'owner': instance.owner,
      'users': instance.users,
      'createdAt': instance.createdAt.toIso8601String(),
      'public': instance.public,
    };
