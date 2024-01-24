import 'package:gogo_mvp_data/datasource/auth/auth_local_data_source.dart';
import 'package:gogo_mvp_data/datasource/chat/chat_remote_data_source.dart';
import 'package:gogo_mvp_data/datasource/gogo/gogo_cache_data_source.dart';
import 'package:gogo_mvp_data/datasource/member/member_remote_data_source.dart';
import 'package:gogo_mvp_data/types/dto/gogo/gogo_info_dto.dart';
import 'package:gogo_mvp_data/types/dto/gogo/gogo_request_dto.dart';
import 'package:gogo_mvp_data/types/types.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_room.dart';
import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';
import 'package:gogo_mvp_domain/repository/gogo_repository.dart';
import '../datasource/gogo/gogo_remote_data_source.dart';

// todo : refactor.
class GogoRepositoryImpl implements GogoRepository {
  final GogoRemoteDataSource _gogoRemoteDataSource;
  final GogoCacheDataSource _gogoCacheDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final MemberRemoteDataSource _memberRemoteDataSource;
  final ChatRemoteDataSource _chatRemoteDataSource;

  GogoRepositoryImpl(
      this._gogoRemoteDataSource,
      this._gogoCacheDataSource,
      this._authLocalDataSource,
      this._memberRemoteDataSource,
      this._chatRemoteDataSource);

  @override
  Future<String> sendGogoRequest(
      {required String title, required String tag}) async {
    final userId = _authLocalDataSource.getUserId();
    assert(userId != null);
    final request = GogoRequestDto(
        title: title, tag: tag, ownerId: userId!, users: [userId]);
    return _gogoRemoteDataSource.sendGogoRequest(request);
  }

  @override
  Future<List<GogoInfo>> getInvitedGogoRequest() async {
    final userId = _authLocalDataSource.getUserId();
    if (userId == null) throw Exception('User is not logged in');

    final gogoInfoDtoList =
        await _gogoRemoteDataSource.getInvitedGogoRequest(userId);
    return _translateGogoInfoDtoToEntityList(gogoInfoDtoList);
  }

  @override
  Stream<List<GogoInfo>> streamInviteGogoRequests() async* {
    final userId = _authLocalDataSource.getUserId();
    if (userId == null) throw Exception('User is not logged in');

    yield* _gogoRemoteDataSource
        .streamInviteGogoRequests(userId)
        .asyncMap(_translateGogoInfoDtoToEntityList);
  }

  @override
  Future<void> acceptGogoInvite(String gogoId) async {
    final userId = _authLocalDataSource.getUserId();
    assert(userId != null);

    await _gogoRemoteDataSource.readGogoInvite(gogoId, userId!);
    await _gogoRemoteDataSource.acceptGogoInvite(gogoId, userId);
  }

  @override
  Future<void> denyGogoInvite(String gogoId) async {
    final userId = _authLocalDataSource.getUserId();
    assert(userId != null);
    return _gogoRemoteDataSource.readGogoInvite(gogoId, userId!);
  }

  @override
  Stream<List<GogoRoomInfo>> streamJoinedGogoRoom() async* {
    final userId = _authLocalDataSource.getUserId();
    if (userId == null) throw Exception('User is not logged in');

    yield* _gogoRemoteDataSource
        .streamJoinedGogoList(userId)
        .asyncMap(_translateAndCacheGogoInfoDtoToEntityList);
  }

  @override
  Future<GogoInfo?> getGogoInfo(String gogoId) async {
    final gogoInfoDto = await _gogoRemoteDataSource.getGogoInfo(gogoId);
    if (gogoInfoDto == null) return null;

    return await _translateGogoInfoDtoToEntityList([gogoInfoDto])
        .then((value) => value.first);
  }

  @override
  Future<void> leaveGogo(String gogoId) async {
    final userId = _authLocalDataSource.getUserId();
    assert(userId != null);
    return _gogoRemoteDataSource.leaveGogo(gogoId, userId!);
  }

  /* ----- Private Methods ----- */

  Future<List<GogoRoomInfo>> _translateAndCacheGogoInfoDtoToEntityList(
      List<GogoInfoDto> infoDtoList) async {
    final gogoInfoList = await _translateGogoInfoDtoToEntityList(infoDtoList);
    final futureTimeMapEntryList = gogoInfoList.map((info) async => MapEntry(
        info.id, await _chatRemoteDataSource.getLastChatTimestamp(info.id)));
    final timeMap = Map.fromEntries(await Future.wait(futureTimeMapEntryList));
    return gogoInfoList
        .map((gogo) => GogoRoomInfo(
            gogo: gogo, lastUpdate: timeMap[gogo.id] ?? gogo.createdAt))
        .toList();
  }

  Future<List<GogoInfo>> _translateGogoInfoDtoToEntityList(
      List<GogoInfoDto> infoDtoList) async {
    final idSet =
        infoDtoList.expand((info) => [info.ownerId, ...info.userIds]).toSet();
    final userMap = await _getUserMapByIdSet(idSet);
    return infoDtoList
        .map((infoDto) => infoDto.toEntity(userMap: userMap))
        .toList();
  }

  Future<UserMap> _getUserMapByIdSet(Set<String> userIdSet) async {
    return _gogoCacheDataSource.getUserMapWithCaching(
        needUserIdSet: userIdSet,
        getUsersByIdAtRemote: _memberRemoteDataSource.getMultipleUserInfo);
  }
}
