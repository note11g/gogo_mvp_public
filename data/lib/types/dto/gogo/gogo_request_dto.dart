import 'package:cloud_firestore/cloud_firestore.dart';

class GogoRequestDto {
  final String title;
  final String tag;
  final String ownerId;
  final List<String> users;
  final String? id;
  final bool public;
  final FieldValue? createdAt;

  const GogoRequestDto({
    required this.title,
    required this.tag,
    required this.ownerId,
    required this.users,
    this.id,
    this.public = true,
    this.createdAt,
  });

  GogoRequestDto copyWith({
    String? title,
    String? tag,
    String? ownerId,
    List<String>? users,
    String? id,
    bool? public,
    FieldValue? createdAt,
  }) =>
      GogoRequestDto(
        title: title ?? this.title,
        tag: tag ?? this.tag,
        ownerId: ownerId ?? this.ownerId,
        users: users ?? this.users,
        id: id ?? this.id,
        public: public ?? this.public,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "tag": tag,
        "ownerId": ownerId,
        "users": users,
        "id": id,
        "public": public,
        "createdAt": createdAt,
      };
}
