import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gogo_mvp_data/types/types.dart';
import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';

class GogoInfoDto {
  final String id;
  final String title;
  final String tag;
  final String ownerId;
  final List<String> userIds;
  final DateTime createdAt;
  final bool public;

  GogoInfoDto({
    required this.id,
    required this.title,
    required this.tag,
    required this.ownerId,
    required this.userIds,
    required this.createdAt,
    required this.public,
  });

  factory GogoInfoDto.fromJson(dynamic json) {
    final rawCreatedAt = json['createdAt'];
    return GogoInfoDto(
      id: json['id'] as String,
      title: json['title'] as String,
      tag: json['tag'] as String,
      ownerId: json['ownerId'] as String,
      userIds: (json['users'] as List).map((e) => e as String).toList(),
      createdAt: rawCreatedAt == null
          ? DateTime.now()
          : (rawCreatedAt as Timestamp).toDate(),
      public: json['public'] as bool,
    );
  }

  GogoInfo toEntity({
    required UserMap userMap,
  }) {
    return GogoInfo(
      id: id,
      title: title,
      tag: tag,
      owner: userMap[ownerId]!,
      users: userIds.map((userId) => userMap[userId]!).toList(),
      createdAt: createdAt,
      public: public,
    );
  }
}
