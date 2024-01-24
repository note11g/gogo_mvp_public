import 'dart:async';
import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_room.dart';
import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'package:gogo_mvp_domain/usecase/gogo/provide_stream_gogo_invite_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/provide_stream_joined_gogo_usecase.dart';
import 'package:gogo_mvp_domain/usecase/user/get_my_info_usecase.dart';
import 'package:view_model_kit/view_model_kit.dart';

class MainContainer extends BaseContainer {
  R<Me?> get me => _me;
  late final _me = createMutable<Me?>(null);

  RList<GogoInfo> get invitedGogoList => _invitedGogoList;
  late final _invitedGogoList = createMutableList<GogoInfo>();

  RList<GogoRoomInfo> get joinedGogoRoomList => _joinedGogoRoomList;
  late final _joinedGogoRoomList = createMutableList<GogoRoomInfo>();

  StreamSubscription<List<GogoInfo>>? _subscriptionGogoInvite;
  StreamSubscription<List<GogoRoomInfo>>? _subscriptionJoinedGogo;

  @override
  void onCreate() {
    me.observe(_onChangedMyInfo);
    _fetchMyInfo();
  }

  void _onChangedMyInfo(Me? changedMe) async {
    if (changedMe == null) {
      _subscriptionGogoInvite?.cancel();
      _subscriptionJoinedGogo?.cancel();
      return;
    }

    _startSubscribeInvitedGogoRequest();
    _startSubscribeJoinedGogo();
  }

  Future<void> _fetchMyInfo() async {
    final getUserInfo = GetIt.I.get<GetMyInfoUseCase>();
    _me.value = await getUserInfo();
  }

  void updateCachedMyInfo(Me? me) {
    if (me == null) {
      // logout.
      _me.value = null;
      return;
    }
    final lastMe = this.me.value;
    if (lastMe == null) {
      // login.
      _me.value = me;
      return;
    }

    _me.value = me.copyWith(id: lastMe.id); // update cache myInfo.
  }

  void _startSubscribeInvitedGogoRequest() {
    _subscriptionGogoInvite?.cancel();

    final streamGogoInvite = GetIt.I.get<ProvideStreamGogoInviteUseCase>();
    _subscriptionGogoInvite = streamGogoInvite().listen((gogoList) {
      log("update: ${gogoList.length}", name: "streamGogoInvite");
      gogoList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _invitedGogoList.change(gogoList);
    });
  }

  void _startSubscribeJoinedGogo() {
    _subscriptionJoinedGogo?.cancel();

    final streamJoinedGogo = GetIt.I.get<ProvideStreamJoinedGogoUseCase>();
    _subscriptionJoinedGogo = streamJoinedGogo().listen((gogoList) {
      log("update: ${gogoList.length}", name: "streamJoinedGogo");
      gogoList.sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));
      _joinedGogoRoomList.change(gogoList);
    });
  }

  void changeGogoRoomLastUpdateTime(String gogoId, DateTime lastUpdate) {
    final room = joinedGogoRoomList.value
        .where((room) => room.gogo.id == gogoId)
        .firstOrNull;
    if (room == null) return;

    _joinedGogoRoomList.value.remove(room);
    final newRoom = room.copyWith(lastUpdate: lastUpdate);

    int foundIndex = 0;
    for (int i = 0; i < joinedGogoRoomList.length; i++) {
      if (lastUpdate.isAfter(joinedGogoRoomList[i].lastUpdate)) {
        foundIndex = i;
        break;
      }
    }

    _joinedGogoRoomList.insert(foundIndex, newRoom);
  }
}
