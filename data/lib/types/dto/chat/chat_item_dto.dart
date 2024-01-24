import 'package:gogo_mvp_data/types/dto/chat/chat_enter_record_dto.dart';
import 'package:gogo_mvp_data/types/dto/chat/chat_message_dto.dart';
import 'package:gogo_mvp_data/types/types.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_items.dart';

import 'chat_leave_record_dto.dart';

abstract class ChatItemDto<Entity extends NetworkChatItem> {
  final String id;
  final String userId;
  final DateTime time;

  List<String> get allUserIdList;

  ChatItemDto({required this.id, required this.userId, required this.time});

  static ChatItemDto fromJson(dynamic json) {
    if (json['message'] != null) {
      return ChatMessageDto.fromJson(json);
    } else if (json['leave'] == true) {
      return ChatLeaveRecordDto.fromJson(json);
    } else {
      return ChatEnterRecordDto.fromJson(json);
    }
  }

  Entity toEntity({required UserMap userMap});
}
