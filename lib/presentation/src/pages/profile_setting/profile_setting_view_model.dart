import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:gogo_mvp/analytics/amplitude_util.dart';
import 'package:gogo_mvp/presentation/src/core/global_container/main_container.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'package:gogo_mvp_domain/usecase/app_info/get_all_tags_use_case.dart';
import 'package:view_model_kit/view_model_kit.dart';
import 'package:gogo_mvp_domain/entity/user/soma_role.dart';
import 'package:gogo_mvp_domain/usecase/user/get_my_info_at_editing_usecase.dart';
import 'package:gogo_mvp_domain/usecase/user/update_my_info_usecase.dart';
import 'package:gogo_mvp_domain/usecase/user/upload_profile_image_usecase.dart';

class ProfileSettingViewModel extends BaseViewModel {
  late final name = createMutable("");

  late final profileImageUrl = createMutable("");

  late final role = createMutable(SomaRole.none);

  late final tags = createMutableList<String>([]);

  bool get iOSReviewMode => Platform.isIOS &&
      RegExp(r"^([A-Za-z\s]{8,31})$").hasMatch(name.value);

  R<bool> get isRegister => _isRegister;
  late final _isRegister = createMutable(true);

  bool get isLoading => allTags.value.isEmpty;

  bool get doneFlag => isValid && hasChange;

  bool get isValid =>
      isNameValid &&
      isProfileImageIsNotEmpty &&
      isRoleNotEmpty &&
      isTagsNotEmpty;

  bool get isNameValid =>
      RegExp(r"^([가-힣]{2,4}|[A-Za-z\s]{8,31})$").hasMatch(name.value);

  bool get isProfileImageIsNotEmpty => profileImageUrl.value.isNotEmpty;

  bool get isRoleNotEmpty => role.value != SomaRole.none;

  bool get isTagsNotEmpty => tags.value.isNotEmpty;

  bool get hasChange {
    final newMyInfo = _makeUserWithNewInfo();
    return newMyInfo.name != _oldMyInfo!.name ||
        newMyInfo.profileImageUrl != _oldMyInfo!.profileImageUrl ||
        newMyInfo.somaRole != _oldMyInfo!.somaRole ||
        (!listEquals(newMyInfo.tags, _oldMyInfo!.tags));
  }

  RList<String> get allTags => _allTags;
  late final _allTags = createMutableList<String>();

  Me? _oldMyInfo;

  @override
  void onReady() async {
    final getMyInfo = GetIt.I.get<GetMyInfoAtEditingUseCase>();
    _oldMyInfo = await getMyInfo.call();

    name.value = _oldMyInfo!.name;
    profileImageUrl.value = _oldMyInfo!.profileImageUrl;
    role.value = _oldMyInfo!.somaRole;
    tags.change(_oldMyInfo!.tags);
    _isRegister.value = _oldMyInfo!.isNewAccount;

    final getAllTags = GetIt.I.get<GetAllTagsUseCase>();
    _allTags.change(await getAllTags.call());
    await AmplitudeUtil.setUserId(_oldMyInfo!.id);
  }

  Future<void> editProfile({
    required void Function() onDone,
    required void Function() onFailedUploadProfileImage,
  }) async {
    try {
      final uploadedProfileImageUrl = await _uploadProfileImageWhenChanged();

      final editedNewMyInfo = _makeUserWithNewInfo(
          overrideProfileImageUrl: uploadedProfileImageUrl);
      await _updateMyInfo(editedNewMyInfo);

      await AmplitudeUtil.setUserProperties(
          {"gogo_tags": editedNewMyInfo.tags});

      onDone();
    } catch (e) {
      onFailedUploadProfileImage();
      log("Failed to edit profile", error: e);
      rethrow;
    }
  }

  Future<String?> _uploadProfileImageWhenChanged() async {
    final isProfileImageChanged =
        profileImageUrl.value != _oldMyInfo!.profileImageUrl;
    if (!isProfileImageChanged) return null;

    return await _uploadProfileImage();
  }

  Future<String> _uploadProfileImage() async {
    final uploadProfileImage = GetIt.I.get<UploadProfileImageUseCase>();
    return uploadProfileImage(filePath: profileImageUrl.value);
  }

  Future<void> _updateMyInfo(Me myInfo) async {
    final updateMyInfo = GetIt.I.get<UpdateMyInfoUseCase>();
    await updateMyInfo(me: myInfo);
    _cacheMyInfoAtGlobalContainer(myInfo);
  }

  void _cacheMyInfoAtGlobalContainer(Me me) {
    final container = GetIt.I.get<MainContainer>();
    container.updateCachedMyInfo(me);
  }

  Me _makeUserWithNewInfo({String? overrideProfileImageUrl}) => Me(
        name: name.value,
        profileImageUrl: overrideProfileImageUrl ?? _oldMyInfo!.profileImageUrl,
        somaRole: role.value,
        tags: tags.value,
        id: _oldMyInfo?.id ?? "",
        email: "",
      );
}
