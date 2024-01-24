import 'package:firebase_database/firebase_database.dart';
import 'package:gogo_mvp_data/types/dto/chat/chat_item_dto.dart';
import 'package:gogo_mvp_data/types/dto/chat/chat_request_dto.dart';

class ChatRemoteDataSource {
  final FirebaseDatabase _firebaseDatabase;

  ChatRemoteDataSource(this._firebaseDatabase);

  DatabaseReference _getChatRoomRef(String gogoId) =>
      _firebaseDatabase.ref('chat_room').child(gogoId);

  DatabaseReference _getChatRef(String gogoId) =>
      _getChatRoomRef(gogoId).child("chats");

  Stream<ChatItemDto> streamNewChat(String gogoId) {
    return _getChatRef(gogoId)
        .onChildAdded
        .map((event) => ChatItemDto.fromJson(event.snapshot.value));
  }

  Stream<ChatItemDto> streamUpdateChatMessageInfo(String gogoId) {
    return _getChatRef(gogoId)
        .onChildChanged
        .map((event) => ChatItemDto.fromJson(event.snapshot.value));
  }

  Future<void> sendChat(String gogoId, ChatMessageRequestDto req) async {
    final createdChatRef = _getChatRef(gogoId).push();
    await createdChatRef.set(req.toJson(id: createdChatRef.key!));
  }

  Future<DateTime?> getLastChatTimestamp(String gogoId) {
    return _getChatRoomRef(gogoId).child("lastUpdate").get().then((snapshot) =>
        snapshot.exists
            ? DateTime.fromMillisecondsSinceEpoch(snapshot.value as int)
            : null);
  }

  Future<void> updateLastChatTimestamp(String gogoId) {
    return _getChatRoomRef(gogoId)
        .child("lastUpdate")
        .set(ServerValue.timestamp);
  }

  Future<void> readChat(String gogoId, String userId, String messageId) async {
    final chatRef = _getChatRef(gogoId).child(messageId);
    await chatRef.child("readUsers").child(userId).set(userId);
  }

  Future<void> enterChatRoomFirst(
      String gogoId, ChatEnterRequestDto req) async {
    final createdChatRef = _getChatRef(gogoId).push();
    await createdChatRef.set(req.toJson(id: createdChatRef.key!));
  }

  Future<void> leaveChatRoom(String gogoId, ChatLeaveRequestDto req) async {
    final createdChatRef = _getChatRef(gogoId).push();
    await createdChatRef.set(req.toJson(id: createdChatRef.key!));
  }
}
