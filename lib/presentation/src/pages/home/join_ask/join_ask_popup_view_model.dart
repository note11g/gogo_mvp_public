import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:gogo_mvp/analytics/amplitude_util.dart';
import 'package:gogo_mvp/presentation/src/core/global_container/main_container.dart';
import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';
import 'package:gogo_mvp_domain/usecase/gogo/accept_gogo_invite_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/deny_gogo_invite_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/get_gogo_info_usecase.dart';
import 'package:view_model_kit/view_model_kit.dart';

class JoinAskPopupViewModel extends BaseViewModel {
  final String gogoId;
  final bool isLinkInvite;
  final void Function() onFindFailed;
  final void Function() onAlreadyJoined;

  JoinAskPopupViewModel({
    required this.gogoId,
    required this.isLinkInvite,
    required this.onFindFailed,
    required this.onAlreadyJoined,
  });

  final _mainContainer = GetIt.I.get<MainContainer>();

  R<GogoInfo?> get info => _info;
  late final _info = createMutable<GogoInfo?>(null);

  @override
  void onReady() async {
    try {
      if (isLinkInvite) {
        _info.value = await _findGogoInfoFromLinkInvite();
      } else {
        _info.value = await _findGogoInfoByTagInvites()
            .timeout(const Duration(seconds: 5));
      }
    } catch (e) {
      onFindFailed();
    } finally {
      await AmplitudeUtil.track("invite_popup_view",
          action: UserAction.enter,
          properties: {
            "gogo_id": info.value?.id ?? "not-found",
          });
    }
  }

  Future<GogoInfo?> _findGogoInfoFromLinkInvite() async {
    final alreadyJoined =
        _mainContainer.joinedGogoRoomList.value.any((e) => e.gogo.id == gogoId);
    if (alreadyJoined) {
      onAlreadyJoined();
      return null;
    }

    final getGogoInfo = GetIt.I.get<GetGogoInfoUseCase>();
    final gogoInfo = await getGogoInfo(gogoId: gogoId);
    if (gogoInfo == null || _mainContainer.me.value == null) {
      onFindFailed();
      return null;
    }
    final alreadyJoined2 =
        gogoInfo.users.any((u) => u.id == _mainContainer.me.value!.id);
    if (alreadyJoined2) {
      onAlreadyJoined();
      return null;
    }
    return gogoInfo;
  }

  Future<void> denyInvite() async {
    final denyGogoInvite = GetIt.I.get<DenyGogoInviteUseCase>();
    await denyGogoInvite(gogoId: info.value!.id);
    await AmplitudeUtil.track("deny_invite_button", properties: {
      "gogo_id": info.value!.id,
    });
  }

  Future<void> acceptInvite() async {
    final acceptGogoInvite = GetIt.I.get<AcceptGogoInviteUseCase>();
    await acceptGogoInvite(gogoId: info.value!.id);
    await AmplitudeUtil.track("accept_invite_button", properties: {
      "gogo_id": info.value!.id,
    });
  }

  Future<GogoInfo> _findGogoInfoByTagInvites() async {
    GogoInfo? hasThisGogo(List<GogoInfo> info) {
      for (final gogo in info) {
        if (gogo.id == gogoId) return gogo;
      }
      return null;
    }

    final gogoInfoListRx = _mainContainer.invitedGogoList;
    final foundGogo = hasThisGogo(gogoInfoListRx.value);
    if (foundGogo != null) return foundGogo;

    final gogoCompleter = Completer<GogoInfo>();

    void tempObserver(List<GogoInfo> list) {
      final foundGogo = hasThisGogo(list);
      if (foundGogo != null) gogoCompleter.complete(foundGogo);
    }

    gogoInfoListRx.observe(tempObserver);

    final result = await gogoCompleter.future;
    gogoInfoListRx.cancelObserve(tempObserver);
    return result;
  }
}
