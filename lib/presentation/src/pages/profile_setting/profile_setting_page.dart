import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gogo_mvp/presentation/src/core/global_container/main_container.dart';
import 'package:gogo_mvp/presentation/src/core/util/apple_login_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/kakao_login_util.dart';
import 'package:gogo_mvp/presentation/src/design/color/go_color.dart';
import 'package:gogo_mvp_domain/entity/auth/login_platform.dart';
import 'package:gogo_mvp_domain/usecase/auth/delete_account_usecase.dart';
import 'package:gogo_mvp_domain/usecase/auth/sign_out_user_usecase.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:view_model_kit/view_model_kit.dart';

import 'package:gogo_mvp_domain/entity/user/soma_role.dart';
import '../../core/routing/routing.dart';
import '../../design/component/components.dart';
import '../../design/typo/typo.dart';
import '../../core/util/loading_util.dart';
import '../../core/util/photo_util.dart';
import '../../core/util/toast_util.dart';
import 'profile_setting_view_model.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState
    extends StateWithViewModel<ProfileSettingPage, ProfileSettingViewModel> {
  @override
  ProfileSettingViewModel createViewModel() => ProfileSettingViewModel();

  final _nameTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.name.observe((name) {
      if (_nameTextFieldController.text != name) {
        _nameTextFieldController.text = name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TextFieldFocusOutHelper(
            child: Stack(children: [
      SafeArea(
          child: Stack(children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(child: _contentListSection()),
          _actionButton(),
        ]),
        if (!viewModel.isRegister.value) _backButtonSection(),
      ])),
      FullScreenLoadingIndicator(isLoading: viewModel.isLoading),
    ])));
  }

  Widget _backButtonSection() => Positioned(
      top: 0,
      left: 12,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: GoColors.secondaryGray),
        alignment: Alignment.centerRight,
        onPressed: () => context.pop(),
      ));

  Widget _contentListSection() => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            _profileSection(),
            const GoSpacer(32),
            _selectionSection(),
            const GoSpacer(24),
            _descriptionSection(),
          ]);

  Widget _actionButton() {
    final actionName = viewModel.isRegister.value ? "회원가입" : "수정";
    return FullCTAButton(actionName, enable: viewModel.doneFlag,
        onDisabledTap: () {
      if (!viewModel.isValid) {
        if (!viewModel.isNameValid) {
          context.openToast("이름을 실명으로 정확히 입력해주세요.");
        } else if (!viewModel.isProfileImageIsNotEmpty) {
          context.openToast("프로필 사진을 등록해주세요.");
        } else if (!viewModel.isRoleNotEmpty) {
          context.openToast("소마에서 어떻게 불리시는지 선택해주세요.");
        } else if (!viewModel.isTagsNotEmpty) {
          context.openToast("소마 사람들과 하고 싶은 걸 모두 골라주세요.");
        }
      } else if (!viewModel.hasChange) {
        context.openToast("수정할 정보가 없어요.");
      }
    }, onTap: () {
      context.load(() => viewModel.editProfile(
          onFailedUploadProfileImage: () =>
              context.openToast("프로필 사진 업로드에 실패하였습니다."),
          onDone: () {
            context.openToast("$actionName에 성공하였습니다.");
            context.go(GoPages.home);
          }));
    });
  }

  Widget _profileSection() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        _profileImageSection(),
        const GoSpacer(24),
        _nameTextFieldSection(),
      ]);

  Widget _profileImageSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      ProfilePhotoView(
          onTap: _startPhotoPick, image: viewModel.profileImageUrl.value),
      const GoSpacer(4),
      LinkButton("사진 수정", underline: false, onTap: _startPhotoPick),
    ]);
  }

  Widget _nameTextFieldSection() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldTypeA(
          controller: _nameTextFieldController,
          label: "이름(실명)",
          hint: "김소마",
          maxLength: 31,
          onChanged: (text) {
            viewModel.name.value = text;
          }));

  Widget _selectionSection() => Column(children: [
        _roleSelectionSection(),
        const GoSpacer(44),
        _tagSelectionSection(),
      ]);

  Widget _roleSelectionSection() => Column(children: [
        Text("소마에서 어떻게 불리시나요?",
            style: GoTypos.titleAtProfileSetting(),
            textAlign: TextAlign.center),
        const GoSpacer(16),
        MultiSelectionButtonUnit(
            selected: viewModel.role.value != SomaRole.none
                ? [viewModel.role.value.kor]
                : [],
            texts: SomaRole.getRoles(includeVisitor: viewModel.iOSReviewMode)
                .map((e) => e.kor)
                .toList(),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            multiSelectionEnable: false,
            onChanged: (list) {
              viewModel.role.value = list.isNotEmpty
                  ? SomaRole.fromKor(list.first)
                  : SomaRole.none;
            }),
      ]);

  Widget _tagSelectionSection() => Column(children: [
        Text("소마 사람들과 하고 싶은 걸 모두 골라주세요",
            style: GoTypos.titleAtProfileSetting(),
            textAlign: TextAlign.center),
        const GoSpacer(4),
        Text("TIP : 선택한 순서대로 홈화면에 보여져요 😉",
            style: GoTypos.descriptionAtProfile(), textAlign: TextAlign.center),
        const GoSpacer(12),
        MultiSelectionButtonUnit(
            selected: viewModel.tags.value,
            texts: viewModel.allTags.value,
            showOrdering: true,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            onChanged: viewModel.tags.change),
      ]);

  Widget _descriptionSection() => Column(children: [
        Row(
            mainAxisSize: MainAxisSize.min,
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text("이런 태그 있으면 좋겠는데?", style: GoTypos.descriptionAtProfile()),
              LinkButton("태그 제안하기",
                  onTap: _openTagSurvey, padding: const EdgeInsets.all(4)),
            ]),
        Text("제안해주신 태그가 추가되면 알려드릴게요!", style: GoTypos.descriptionAtProfile()),
        if (!viewModel.isRegister.value)
          _logoutOrDeleteAccountDialogOpenButton(),
      ]);

  Widget _logoutOrDeleteAccountDialogOpenButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("로그아웃을 찾으시나요?", style: GoTypos.descriptionAtProfile()),
          LinkButton("계정 관리",
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => _AccountSettingDialog()),
              padding: const EdgeInsets.all(4)),
        ],
      ),
    );
  }

  void _startPhotoPick() async {
    try {
      final compressedImage = await context.load(
          () => PhotoUtil.pickImageFromGalleryAndCompressImage(
              format: CompressFormat.webp, compressQuality: 50),
          errorToast: false);
      if (compressedImage == null) return;
      viewModel.profileImageUrl.value = compressedImage;
    } on PhotoUtilException catch (e) {
      context.openToast(e.message);
    }
  }

  void _openTagSurvey() async {
    const url = "https://t0xa32reo6x.typeform.com/to/es2ZbDm5";
    if (!await launchUrlString(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

class _AccountSettingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoDialog(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("계정 관리", style: GoTypos.updateDialogTitle()),
                RawButton(
                    padding: const EdgeInsets.all(4),
                    onTap: () => context.pop(),
                    child: const Icon(Icons.close_rounded,
                        color: GoColors.secondaryGray))
              ]),
          const GoSpacer(16),
          Text("로그아웃을 원하시나요?", style: GoTypos.updateDialogDescription()),
          LinkButton("로그아웃",
              onTap: () => _logout(context),
              padding: const EdgeInsets.symmetric(vertical: 6)),
          const GoSpacer(20),
          Text("계정 삭제를 원하시나요?", style: GoTypos.updateDialogDescription()),
          LinkButton("계정 삭제",
              onTap: () => _deleteAccount(context),
              padding: const EdgeInsets.symmetric(vertical: 6)),
        ]));
  }

  void _logout(BuildContext context) {
    _cacheClear();
    context.load(GetIt.I.get<SignOutUserUseCase>()).then((_) {
      context.go(GoPages.welcome);
      context.openToast("로그아웃 되었습니다.");
    });
  }

  void _deleteAccount(BuildContext context) {
    Future<void> deleteAccount() => GetIt.I.get<DeleteAccountUseCase>().call(
            onNeedReAuthenticate: (platform) async {
          await context.openToast("계정 보안을 위해, 다시 로그인을 진행합니다.", seconds: 2);
          return switch (platform) {
            GoLoginPlatform.kakao => KakaoLoginUtil.signInWithKakao(),
            GoLoginPlatform.apple => AppleLoginUtil.signInWithApple(),
          };
        });

    context.load(deleteAccount).then((_) {
      _cacheClear();
      context.go(GoPages.welcome);
      context.openToast("계정이 삭제되었습니다.");
    });
  }

  void _cacheClear() {
    GetIt.I.get<MainContainer>().updateCachedMyInfo(null);
  }
}
