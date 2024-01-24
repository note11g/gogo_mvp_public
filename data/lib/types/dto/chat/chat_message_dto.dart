import 'package:gogo_mvp_data/types/types.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_items.dart';

import 'chat_item_dto.dart';

class ChatMessageDto extends ChatItemDto<ChatMessage> {
  final String message;
  final List<String> readUsers;

  ChatMessageDto({
    required super.id,
    required super.userId,
    required super.time,
    required this.message,
    required this.readUsers,
  });

  @override
  List<String> get allUserIdList => [userId, ...readUsers];

  factory ChatMessageDto.fromJson(dynamic json) {
    assert(json is Map);
    final readUsersMap = json['readUsers'] as Map?;
    return ChatMessageDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] as int),
      readUsers: [...?readUsersMap?.values.cast<String>()],
    );
  }

  @override
  ChatMessage toEntity({required UserMap userMap}) {
    return ChatMessage(
      id: id,
      user: userMap[userId]!,
      message: message,
      time: time,
      readUsers: readUsers.map((userId) => userMap[userId]!).toList(),
    );
  }

  @override
  String toString() {
    return 'ChatMessageDto{id: $id, userId: $userId, message: $message, time: $time, readUsers: $readUsers}';
  }
}
