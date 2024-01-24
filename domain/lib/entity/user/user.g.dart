// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      somaRole: $enumDecode(_$SomaRoleEnumMap, json['somaRole']),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
      'somaRole': _$SomaRoleEnumMap[instance.somaRole]!,
    };

const _$SomaRoleEnumMap = {
  SomaRole.trainee: 'trainee',
  SomaRole.mentor: 'mentor',
  SomaRole.expert: 'expert',
  SomaRole.oldTrainee: 'oldTrainee',
  SomaRole.none: 'none',
};
