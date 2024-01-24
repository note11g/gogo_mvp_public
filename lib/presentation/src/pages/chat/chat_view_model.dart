import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:gogo_mvp/analytics/amplitude_util.dart';
import 'package:gogo_mvp/presentation/src/core/global_container/main_container.dart';
import 'package:gogo_mvp/presentation/src/core/util/loading_util.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_items.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_room.dart';
import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';
import 'package:gogo_mvp_domain/entity/report/reports.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'package:gogo_mvp_domain/entity/user/user.dart';
import 'package:gogo_mvp_domain/usecase/gogo/get_gogo_info_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/leave_gogo_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/provide_stream_chat_new_message_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/provide_stream_chat_updated_message_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/read_chat_message_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/report_chat_message_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/send_chat_image_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/send_chat_message_usecase.dart';
import 'package:view_model_kit/view_model_kit.dart';

class ChatViewModel extends BaseViewModel {
  final void Function() onNotFoundGogoInfo;
  final String gogoId;
  final _mainContainer = GetIt.I.get<MainContainer>();

  ChatViewModel(this.gogoId, {required this.onNotFoundGogoInfo});

  R<Me?> get me => _me;
  late final _me = createMutable<Me?>(null);

  R<GogoInfo?> get gogoInfo => _gogoInfo;
  late final _gogoInfo = createMutable<GogoInfo?>(null);

  RList<ChatItem> get chatItems => _chatItems;
  late final _chatItems = createMutableList<ChatItem>();

  RSet<User> get users => _users;
  late final _users = createMutableSet<User>();

  late final textFieldMessage = createMutable<String>("");

  StreamSubscription? _chatAddedSubscription;
  StreamSubscription? _chatUpdateSubscription;

  @override
  void onReady() async {
    _me.value = await waitRxValueWhenLoaded(_mainContainer.me);
    _mainContainer.joinedGogoRoomList.observe(_joinGogoRoomListChanged);
    if (_mainContainer.joinedGogoRoomList.isNotEmpty) {
      _joinGogoRoomListChanged(_mainContainer.joinedGogoRoomList.value);
    }

    await _fetchGogoInfo();
    _startChatSubscribe();
  }

  void _joinGogoRoomListChanged(List<GogoRoomInfo> info) {
    final isNotJoinedRoom = !info.any((room) => room.gogo.id == gogoId);
    if (isNotJoinedRoom) onNotFoundGogoInfo();
  }

  Future<void> _fetchGogoInfo() async {
    final getGogoInfo = GetIt.I.get<GetGogoInfoUseCase>();
    _gogoInfo.value = await getGogoInfo(gogoId: gogoId);
    if (gogoInfo.value == null) onNotFoundGogoInfo();
  }

  void _startChatSubscribe() async {
    _chatAddedSubscription?.cancel();
    _chatUpdateSubscription?.cancel();
    final subscribeChatAdded =
        GetIt.I.get<ProvideStreamChatNewMessageUseCase>();
    final subscribeChatUpdate =
        GetIt.I.get<ProvideStreamChatUpdatedMessageUseCase>();

    _chatAddedSubscription =
        subscribeChatAdded(gogoId).listen(_onNewMessageReceived);
    _chatUpdateSubscription =
        subscribeChatUpdate(gogoId).listen(_onMessageUpdated);
  }

  void _onMessageUpdated(NetworkChatItem chatItem) {
    final index = chatItems.value
        .indexWhere((item) => item is ChatMessage && item.id == chatItem.id);
    final hasMessage = index != -1;
    if (hasMessage) {
      _chatItems[index] = chatItem;
    }
  }

  void _onNewMessageReceived(NetworkChatItem chatItem) {
    if (chatItem is ChatEnterRecord) _users.add(chatItem.user);
    if (chatItem is ChatLeaveRecord) _users.remove(chatItem.user);
    if (_needAddDateItem(chatItem)) {
      _chatItems.insert(0, ChatDate(time: chatItem.time));
    }
    _chatItems.insert(0, chatItem);
    _mainContainer.changeGogoRoomLastUpdateTime(gogoId, chatItem.time);
  }

  bool _needAddDateItem(ChatItem newChatItem) {
    final lastChatTime = chatItems.value.firstOrNull?.time;
    if (lastChatTime == null) return true;
    return _isDifferentDay(lastChatTime, newChatItem.time);
  }

  bool _isDifferentDay(DateTime time1, DateTime time2) =>
      time1.year != time2.year ||
      time1.month != time2.month ||
      time1.day != time2.day;

  void sendMessage() async {
    if (textFieldMessage.value.isEmpty) return;

    final latestMessage = chatItems.value.firstOrNull;

    final message = textFieldMessage.value.trim();
    textFieldMessage.value = "";

    final sendChatMessage = GetIt.I.get<SendChatMessageUseCase>();
    await sendChatMessage(gogoId: gogoId, message: message);

    await _readMessageWhenMessageUserSent(latestMessage: latestMessage);
    await AmplitudeUtil.track("send_message_button", properties: {
      "gogo_id": gogoId,
      "people_count": users.value.length,
    });
  }

  Future<void> _readMessageWhenMessageUserSent(
      {required ChatItem? latestMessage}) async {
    if (latestMessage is ChatMessage &&
        latestMessage.user.id != me.value?.id &&
        !latestMessage.readUsers.map((u) => u.id).contains(me.value?.id)) {
      await readMessage(messageId: latestMessage.id, auto: true);
    }
  }

  Future<void> sendImage(String localPath) async {
    final sendChatImage = GetIt.I.get<SendChatImageUseCase>();
    await sendChatImage(gogoId: gogoId, localImagePath: localPath);
  }

  Future<void> readMessage(
      {required String messageId, bool auto = false}) async {
    final readMessage = GetIt.I.get<ReadChatMessageUseCase>();
    await readMessage(gogoId: gogoId, messageId: messageId);

    if (!auto) {
      await AmplitudeUtil.track("read_message_button", properties: {
        "gogo_id": gogoId,
        "people_count": users.value.length,
      });
    }
  }

  void reportMessage(
      {required String messageId, required String reportMessage}) async {
    final reportChatMessage = GetIt.I.get<ReportChatMessageUseCase>();
    await reportChatMessage(ChatMessageReport(
        gogoId: gogoId, chatId: messageId, reportMessage: reportMessage));
  }

  Future<void> leaveGogo() async {
    final leaveGogo = GetIt.I.get<LeaveGogoUseCase>();
    await leaveGogo(gogoId: gogoId);

    await AmplitudeUtil.track("gogo_leave_button", properties: {
      "gogo_id": gogoId,
      "people_count": users.value.length,
    });
  }

  @override
  void dispose() {
    _mainContainer.joinedGogoRoomList.cancelObserve(_joinGogoRoomListChanged);
    _chatAddedSubscription?.cancel();
    _chatUpdateSubscription?.cancel();
    super.dispose();
  }
}
