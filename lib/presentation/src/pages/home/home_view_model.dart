import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:gogo_mvp/analytics/amplitude_util.dart';
import 'package:gogo_mvp/presentation/src/core/global_container/main_container.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'package:gogo_mvp_domain/usecase/gogo/send_gogo_request_usecase.dart';
import 'package:view_model_kit/view_model_kit.dart';

class HomeViewModel extends BaseViewModel {
  MainContainer get mainContainer => GetIt.I.get();

  R<Me?> get me => _me;
  late final _me = createMutable<Me?>(mainContainer.me.value);

  late final selectedTag = createMutable<String?>(null);
  late final goGoDetailTextField = createMutable<String>("");

  Future<void> makeGoGoRequest({
    required void Function(Exception e) onFailed,
    required void Function(String gogoId) onDone,
  }) async {
    try {
      final sendGogoRequest = GetIt.I.get<SendGogoRequestUseCase>();
      final gogoId = await sendGogoRequest(
          title: "${goGoDetailTextField.value} ㄱㄱ?", tag: selectedTag.value!);
      _clearGogoRequestInfo();
      await AmplitudeUtil.track("gogo_request_button");
      onDone(gogoId);
    } catch (e) {
      onFailed(e as Exception);
    }
  }

  void _clearGogoRequestInfo() {
    selectedTag.value = null;
    goGoDetailTextField.value = "";
  }

  /// [Me]가 변경되었을 때 호출되는 콜백
  void _onChangedMyInfo(Me? me) async {
    if (me == null) return;
    if (me.tags.contains(selectedTag.value) == false) selectedTag.value = null;
  }

  @override
  void onReady() {
    _onChangedMyInfo(me.value);
    mainContainer.me.observe(_myInfoObserver);
  }

  @override
  void dispose() {
    mainContainer.me.cancelObserve(_myInfoObserver);
    super.dispose();
  }

  void _myInfoObserver(Me? changedMe) {
    _me.value = changedMe;
    _onChangedMyInfo(me.value);
  }
}
