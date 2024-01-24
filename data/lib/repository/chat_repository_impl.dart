import 'package:gogo_mvp_data/datasource/auth/auth_local_data_source.dart';
import 'package:gogo_mvp_data/datasource/chat/chat_remote_data_source.dart';
import 'package:gogo_mvp_data/datasource/gogo/gogo_cache_data_source.dart';
import 'package:gogo_mvp_data/datasource/member/member_remote_data_source.dart';
import 'package:gogo_mvp_data/types/dto/chat/chat_item_dto.dart';
import 'package:gogo_mvp_data/types/dto/chat/chat_request_dto.dart';
import 'package:gogo_mvp_data/types/types.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_items.dart';
import 'package:gogo_mvp_domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final GogoCacheDataSource _gogoCacheDataSource;
  final MemberRemoteDataSource _memberRemoteDataSource;

  ChatRepositoryImpl(this._chatRemoteDataSource, this._authLocalDataSource,
      this._gogoCacheDataSource, this._memberRemoteDataSource);

  @override
  Stream<NetworkChatItem> streamChatItems(String gogoId) {
    return _chatRemoteDataSource
        .streamNewChat(gogoId)
        .asyncMap(_translateChatItemDtoToEntity);
  }

  @override
  Stream<NetworkChatItem> streamChatMessageUpdate(String gogoId) {
    return _chatRemoteDataSource
        .streamUpdateChatMessageInfo(gogoId)
        .asyncMap(_translateChatItemDtoToEntity);
  }

  Future<NetworkChatItem> _translateChatItemDtoToEntity(
      ChatItemDto chatItemDto) async {
    final userIdSet = chatItemDto.allUserIdList.toSet();
    final userMap = await _getUserMapByIdSet(userIdSet);
    return chatItemDto.toEntity(userMap: userMap);
  }

  Future<UserMap> _getUserMapByIdSet(Set<String> userIdSet) async {
    return _gogoCacheDataSource.getUserMapWithCaching(
        needUserIdSet: userIdSet,
        getUsersByIdAtRemote: _memberRemoteDataSource.getMultipleUserInfo);
  }

  @override
  Future<void> sendMessage(
      {required String gogoId, required String message}) async {
    final uid = _authLocalDataSource.getUserId()!;
    await _chatRemoteDataSource.sendChat(
        gogoId, ChatMessageRequestDto(userId: uid, message: message));
    await _chatRemoteDataSource.updateLastChatTimestamp(gogoId);
  }

  @override
  Future<void> readMessage(
      {required String gogoId, required String messageId}) {
    final uid = _authLocalDataSource.getUserId()!;
    return _chatRemoteDataSource.readChat(gogoId, uid, messageId);
  }

  @override
  Future<void> enterChatRoomFirst(String gogoId) async {
    final uid = _authLocalDataSource.getUserId()!;
    await _chatRemoteDataSource.enterChatRoomFirst(
        gogoId, ChatEnterRequestDto(userId: uid));
    await _chatRemoteDataSource.updateLastChatTimestamp(gogoId);
  }

  @override
  Future<void> leaveChatRoom(String gogoId) async {
    final uid = _authLocalDataSource.getUserId()!;
    await _chatRemoteDataSource.updateLastChatTimestamp(gogoId);
    await _chatRemoteDataSource.leaveChatRoom(
        gogoId, ChatLeaveRequestDto(userId: uid));
  }
}
