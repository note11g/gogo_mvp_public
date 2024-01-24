import 'package:gogo_mvp_data/types/types.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_items.dart';

import 'chat_item_dto.dart';

class ChatEnterRecordDto extends ChatItemDto<ChatEnterRecord> {
  ChatEnterRecordDto({
    required super.id,
    required super.userId,
    required super.time,
  });

  @override
  List<String> get allUserIdList => [userId];

  factory ChatEnterRecordDto.fromJson(dynamic json) {
    assert(json is Map);
    return ChatEnterRecordDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] as int),
    );
  }

  @override
  ChatEnterRecord toEntity({required UserMap userMap}) {
    return ChatEnterRecord(id: id, user: userMap[userId]!, time: time);
  }

  @override
  String toString() {
    return 'ChatEnterRecord{id: $id, userId: $userId, time: $time}';
  }
}
