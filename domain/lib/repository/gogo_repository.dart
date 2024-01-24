import 'package:gogo_mvp_domain/entity/chat/chat_room.dart';
import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';

abstract interface class GogoRepository {
  Future<String> sendGogoRequest({required String title, required String tag});

  Future<List<GogoInfo>> getInvitedGogoRequest();

  Stream<List<GogoInfo>> streamInviteGogoRequests();

  Future<void> denyGogoInvite(String gogoId);

  Future<void> acceptGogoInvite(String gogoId);

  Stream<List<GogoRoomInfo>> streamJoinedGogoRoom();

  Future<GogoInfo?> getGogoInfo(String gogoId);

  Future<void> leaveGogo(String gogoId);
}
