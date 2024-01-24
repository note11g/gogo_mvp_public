import 'package:gogo_mvp_domain/entity/chat/chat_items.dart';

abstract interface class ChatRepository {
  Stream<NetworkChatItem> streamChatItems(String gogoId);

  Stream<NetworkChatItem> streamChatMessageUpdate(String gogoId);

  Future<void> sendMessage({required String gogoId, required String message});

  Future<void> readMessage({required String gogoId, required String messageId});

  Future<void> enterChatRoomFirst(String gogoId);

  Future<void> leaveChatRoom(String gogoId);
}
