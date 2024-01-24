import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gogo_mvp/analytics/amplitude_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/keyboard_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/loading_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/measure_util.dart';
import 'package:gogo_mvp/presentation/src/core/util/toast_util.dart';
import 'package:gogo_mvp/presentation/src/design/color/go_color.dart';
import 'package:gogo_mvp/presentation/src/design/component/components.dart';
import 'package:gogo_mvp/presentation/src/design/round/round.dart';
import 'package:gogo_mvp/presentation/src/design/typo/typo.dart';
import 'package:gogo_mvp/presentation/src/core/util/string_util.dart';
import 'package:gogo_mvp/presentation/src/core/routing/routing.dart';
import 'package:gogo_mvp/presentation/src/pages/home/home_view_model.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_room.dart';
import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';
import 'package:view_model_kit/view_model_kit.dart';

/// App Entry Point
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends StateWithViewModel<HomePage, HomeViewModel> {
  @override
  HomeViewModel createViewModel() => HomeViewModel();

  final _gogoDetailTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startObserveUserTextFromTextField();
    AmplitudeUtil.track("home_page", action: UserAction.enter);
  }

  /// observe user text from text field
  void startObserveUserTextFromTextField() {
    viewModel.goGoDetailTextField.observe((gogoText) {
      if (_gogoDetailTextFieldController.text != gogoText) {
        _gogoDetailTextFieldController.text = gogoText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, _) => Scaffold(
            backgroundColor: GoColors.backgroundGray,
            resizeToAvoidBottomInset: false,
            body: TextFieldFocusOutHelper(
                child: SafeArea(
              bottom: false,
              maintainBottomViewPadding: false,
              child: Stack(children: [
                ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 160),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      _profileSection(context),
                      _gogoSection(context),
                      const GoDivider(verticalMargin: 32),
                      _recentGoGoSection(context),
                    ]),
                Positioned.fill(
                    top: null,
                    child: _GoGoRequestSection(
                        requests: viewModel.mainContainer.invitedGogoList)),
              ]),
            ))));
  }

  Widget _profileSection(BuildContext context) {
    return SelectBuilder(
        rx: viewModel.me,
        builder: (context, myInfo) {
          return RawButton(
            onTap: () => context.push(GoPages.profileSetting),
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Row(children: [
              ProfilePhotoView(size: 48, image: myInfo?.profileImageUrl ?? ""),
              const GoSpacer(12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                    (myInfo != null
                        ? "${myInfo.name} (${myInfo.somaRole.kor})"
                        : ""),
                    style: GoTypos.profileNameTextAtHome()),
                const GoSpacer(6),
                Text("프로필/해시태그 수정하기 >", style: GoTypos.profileLinkTextAtHome()),
              ]),
            ]),
          );
        });
  }

  Widget _gogoSection(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _gogoTagSelectionSection(context),
        const GoSpacer(12),
        _gogoTextFieldSection(context),
      ]);

  Widget _gogoTagSelectionSection(BuildContext context) => SelectBuilder(
      rx: viewModel.me,
      builder: (context, myInfo) {
        return Row(children: [
          Text("지금", style: GoTypos.titleAtHome()),
          TagSelectionSection(
              snapPosition: 80,
              rxSelectedTag: viewModel.selectedTag,
              tags: myInfo?.tags ?? []),
          Text(",", style: GoTypos.titleAtHome()),
        ]);
      });

  Widget _gogoTextFieldSection(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
            child: TextFieldTypeB(
          controller: _gogoDetailTextFieldController,
          hint: "서브웨이 같이",
          maxLength: 30,
          onChanged: (value) => viewModel.goGoDetailTextField.value = value,
        )),
        const GoSpacer(12),
        SelectBuilder(
            rx: viewModel.selectedTag,
            builder: (context, tag) {
              return SelectBuilder(
                  rx: viewModel.goGoDetailTextField,
                  builder: (context, gogoDetail) {
                    return MinCTAButton("ㄱㄱ?",
                        enable: tag != null && gogoDetail.length >= 2,
                        onDisabledTap: () {
                      if (tag == null) {
                        context.openToast("해시태그를 선택해주세요.");
                      } else {
                        context.openToast("ㄱㄱ 내용을 2글자 이상 입력해주세요.");
                      }
                    }, onTap: () {
                      HapticFeedback.heavyImpact();
                      KeyboardUtil.hideKeyboard(context);
                      context.load(() => viewModel.makeGoGoRequest(
                          onFailed: (e) =>
                              context.openToast("ㄱㄱ 요청에 실패했어요.\n($e)"),
                          onDone: (gogoId) {
                            context.openToast("ㄱㄱ가 생성되었어요!");
                            context.push(GoPages.chat(id: gogoId));
                          }));
                    });
                  });
            }),
      ]);

  Widget _recentGoGoSection(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text("최근 참여한 ㄱㄱ 목록", style: GoTypos.titleAtHome()),
        const GoSpacer(12),
        SelectBuilder(
            rx: viewModel.mainContainer.joinedGogoRoomList,
            builder: (context, joinedGogoList) => GoDivideColumn(
                divider: const GoDivider(),
                children: joinedGogoList
                    .map((info) => _RecentGoGoRoomItem(info))
                    .toList())),
      ]);
}

class _RecentGoGoRoomItem extends StatelessWidget {
  final GogoRoomInfo info;

  const _RecentGoGoRoomItem(this.info);

  @override
  Widget build(BuildContext context) {
    return RawButton(
        onTap: () => context.push(GoPages.chat(id: info.gogo.id)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ProfilePhotoView(size: 40, image: info.gogo.owner.profileImageUrl),
          const GoSpacer(12),
          Expanded(
              child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                  child: Text(info.gogo.title,
                      style: GoTypos.titleAtHomeRecent())),
              Text(info.lastUpdate.toBeforeDateString(),
                  style: GoTypos.descriptionAtHomeRecent()),
            ]),
            const GoSpacer(4),
            Row(children: [
              Text(info.gogo.tag, style: GoTypos.tagAtHomeRecent()),
              const GoSpacer(6),
              Text(_usersText, style: GoTypos.descriptionAtHomeRecent()),
            ])
          ]))
        ]));
  }

  String get _usersText => info.gogo.users
      .map((user) => user.name)
      .toList()
      .toPersonTextString(maxShowCount: 3);
}

class _GoGoRequestSection extends StatefulWidget {
  final RList<GogoInfo> requests;

  const _GoGoRequestSection({required this.requests});

  @override
  State<_GoGoRequestSection> createState() => _GoGoRequestSectionState();
}

class _GoGoRequestSectionState extends State<_GoGoRequestSection> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SelectBuilder(
        rx: widget.requests,
        builder: (context, requests) {
          if (requests.isEmpty) return const SizedBox();

          return Column(mainAxisSize: MainAxisSize.min, children: [
            if (requests.length > 1 && pageIndex != requests.length - 1)
              _balloonGuide(requests.length - 1 - pageIndex),
            AutoHeightPageView(
                onPageChanged: (index) => setState(() => pageIndex = index),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24).copyWith(
                    bottom: MediaQuery.paddingOf(context).bottom + 24),
                children: requests.map((e) => requestItem(e)).toList()),
          ]);
        });
  }

  Widget _balloonGuide(int count) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(right: 6),
      child: Balloon(
          color: GoColors.white,
          shadowColor: GoColors.black.withOpacity(0.24),
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text("요청이 $count개 더 있어요", style: GoTypos.requestTipTextAtHome()),
            const GoSpacer(2),
            const GoIcon(
                name: "slide_arrow_right",
                size: 15,
                color: GoColors.primaryOrange),
          ])),
    );
  }

  Widget requestItem(GogoInfo info) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: GoRounds.m.borderRadius,
            color: GoColors.white,
            boxShadow: [
              BoxShadow(
                color: GoColors.black.withOpacity(0.12),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("지금 온 ㄱㄱ 요청!!", style: GoTypos.requestPrimaryTextAtHome()),
                const GoSpacer(6),
                Text(info.title,
                    style: GoTypos.requestTitleTextAtHome(),
                    overflow: TextOverflow.ellipsis),
                const GoSpacer(6),
                Text.rich(TextSpan(
                    style: GoTypos.requestDescriptionTextAtHome(),
                    children: [
                      TextSpan(
                          text:
                              "${info.users.map((user) => user.name).toList().toPersonTextString(maxShowCount: 2)}의 "),
                      TextSpan(
                          text: info.tag,
                          style: GoTypos.requestPrimaryTextAtHome()),
                      const TextSpan(text: "팟"),
                    ])),
              ])),
          const GoSpacer(12),
          TextBaseButton("자세히 보기",
              onTap: () => context.push(GoPages.askJoin(id: info.id)),
              padding: const EdgeInsets.all(12),
              textStyle: GoTypos.halfCTAButtonText(size: 13)),
        ]));
  }
}

class TagSelectionSection extends StatefulWidget {
  final List<String> tags;
  final MutableR<String?> rxSelectedTag;
  final double snapPosition;
  final double gap;

  const TagSelectionSection({
    super.key,
    required this.tags,
    required this.rxSelectedTag,
    this.snapPosition = 52,
    this.gap = 4,
  });

  @override
  State<TagSelectionSection> createState() => _TagSelectionSectionState();
}

class _TagSelectionSectionState extends State<TagSelectionSection> {
  final ScrollController _scrollController = ScrollController();
  double lastMeasuredScrollViewWidth = 0;
  double lastMeasuredScrollViewContentWidth = 0;

  @override
  Widget build(BuildContext context) {
    return FadeHorizontalScrollableView(
      controller: _scrollController,
      backgroundColor: GoColors.backgroundGray,
      onMeasured: (width, maxWidth) {
        lastMeasuredScrollViewWidth = maxWidth;
        lastMeasuredScrollViewContentWidth = width;
      },
      child: SelectBuilder(
          rx: widget.rxSelectedTag,
          builder: (context, selectedTag) {
            double selectedTagPosition = 0;
            bool positionFound = selectedTag == null;
            final List<MultiSelectionButton> resultRowChildren = [];
            for (final tag in widget.tags) {
              final selected = selectedTag == tag;
              final button = MultiSelectionButton(tag,
                  selected: selected,
                  onTap: () => _tagTapped(tag: tag, nowSelected: selected));
              resultRowChildren.add(button);

              if (!positionFound) {
                if (selected) {
                  positionFound = true;
                  selectedTagPosition = _calibratePosition(selectedTagPosition);
                } else if (selectedTag != null) {
                  selectedTagPosition += _measureWidth(button) + widget.gap;
                }
              }
            }

            if (selectedTag != null) _scheduleScroll(selectedTagPosition);

            return GoRow(spacing: widget.gap, children: resultRowChildren);
          }),
    );
  }

  double _measureWidth(Widget widget) => MeasureUtil.measureWidgetSize(widget,
          context: context, constraintType: MeasureConstraintType.infinity)
      .width;

  double _calibratePosition(double position) {
    position -= widget.snapPosition;

    final isLeftOverScroll = position < 0;
    if (isLeftOverScroll) return 0;

    final overRightScrollWidth = lastMeasuredScrollViewWidth -
        (lastMeasuredScrollViewContentWidth - position);
    final isRightOverScroll = overRightScrollWidth > 0;
    if (isRightOverScroll) return _scrollController.position.maxScrollExtent;

    return position;
  }

  /// scroll to selected tag (after build)
  void _scheduleScroll(double position) {
    _runAfterBuild(() {
      _scrollController.animateTo(position,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void _runAfterBuild(void Function() callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }

  void _tagTapped({required String tag, required bool nowSelected}) {
    widget.rxSelectedTag.value = nowSelected ? null : tag;
  }
}
