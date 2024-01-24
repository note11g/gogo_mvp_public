// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Me _$$_MeFromJson(Map<String, dynamic> json) => _$_Me(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      email: json['email'] as String,
      somaRole: $enumDecode(_$SomaRoleEnumMap, json['somaRole']),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_MeToJson(_$_Me instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
      'email': instance.email,
      'somaRole': _$SomaRoleEnumMap[instance.somaRole]!,
      'tags': instance.tags,
    };

const _$SomaRoleEnumMap = {
  SomaRole.trainee: 'trainee',
  SomaRole.mentor: 'mentor',
  SomaRole.expert: 'expert',
  SomaRole.oldTrainee: 'oldTrainee',
  SomaRole.none: 'none',
};
