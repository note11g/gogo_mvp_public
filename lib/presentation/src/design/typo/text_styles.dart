part of go_design_typo;

class GoTypos {
  static const multiSelectionButtonText = GoTextStyle._(
      fontInfo: FontInfo.nanum, size: 15, weight: _w7, color: GoColors.white);

  static const multiSelectionButtonOrderNumber = GoTextStyle._(
      fontInfo: FontInfo.nanum, size: 10, weight: _w8, color: GoColors.primaryOrange);

  static const linkText = GoTextStyle._(
      fontInfo: FontInfo.nanum,
      size: 12,
      weight: _w7,
      color: GoColors.linkBlue,
      underline: true);

  static const fullCTAButtonText = GoTextStyle._(
      fontInfo: FontInfo.nanum, size: 15, weight: _w8, color: GoColors.white);

  static const halfCTAButtonText = GoTextStyle._(
      fontInfo: FontInfo.nanum, size: 15, weight: _w8, color: GoColors.white);
  static final halfCTAButtonSecondaryText =
      halfCTAButtonText._copyWith(weight: _w5);

  static const minCTAButtonText = GoTextStyle._(
      fontInfo: FontInfo.nanum, size: 16, weight: _w8, color: GoColors.white);

  static const inputText =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 15, weight: _w7);
  static final inputLabelText =
      inputText._copyWith(weight: _w5, color: GoColors.secondaryGray);

  // ---- temp ----

  // welcome
  static const socialLoginButton =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 17, weight: _w6);

  // profile
  static const titleAtProfileSetting =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 16, weight: _w7);

  static const descriptionAtProfile = GoTextStyle._(
      fontInfo: FontInfo.nanum,
      size: 12,
      weight: _w5,
      color: GoColors.secondaryGray);

  // home
  static const titleAtHome =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 18, weight: _w7);

  static const titleAtHomeRecent =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 15, weight: _w7);

  static const descriptionAtHomeRecent = GoTextStyle._(
      fontInfo: FontInfo.nanum,
      size: 12,
      weight: _w5,
      color: GoColors.secondaryGray);

  static final tagAtHomeRecent = descriptionAtHomeRecent._copyWith(
      color: GoColors.primaryOrange, weight: _w8);

  static const inputTextAtHome =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 16, weight: _w7);

  static const smallCTAButtonTextAtHome = halfCTAButtonText;

  static const profileNameTextAtHome =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 16, weight: _w7);

  static const profileLinkTextAtHome = linkText;

  static const requestDescriptionTextAtHome = GoTextStyle._(
      fontInfo: FontInfo.nanum,
      size: 12,
      weight: _w7,
      color: GoColors.disabledGray);

  static final requestPrimaryTextAtHome =
      requestDescriptionTextAtHome._copyWith(color: GoColors.primaryOrange);

  static const requestTitleTextAtHome =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 18, weight: _w7);

  static const requestTipTextAtHome = GoTextStyle._(
      fontInfo: FontInfo.nanum,
      size: 13,
      weight: _w8,
      color: GoColors.primaryOrange);

  // ask join
  static const tagAtAskJoin = GoTextStyle._(
      fontInfo: FontInfo.nanum,
      size: 12,
      weight: _w8,
      color: GoColors.primaryOrange);

  static const titleAtAskJoin =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 20, weight: _w7);

  static const subTitleAtAskJoin =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 14, weight: _w7);

  static const profileNameTextAtAskJoin =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 14, weight: _w7);

  // chat
  static const appBarTitleAtChat =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 14, weight: _w7);

  static final appBarTagAtChat =
      appBarTitleAtChat._copyWith(color: GoColors.primaryOrange);

  static const appBarDescriptionAtChat = GoTextStyle._(
      fontInfo: FontInfo.pretend,
      size: 12,
      weight: _w6,
      color: GoColors.secondaryGray);

  static const chatMessageText = GoTextStyle._(
    fontInfo: FontInfo.pretend,
    size: 14,
    weight: _w6,
  );

  static const chatDescriptionText = GoTextStyle._(
      fontInfo: FontInfo.pretend,
      size: 12,
      weight: _w6,
      color: GoColors.secondaryGray);

  static final profileNameTextAtChat =
      chatDescriptionText._copyWith(color: GoColors.black);

  static const inputTextAtChat =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 14, weight: _w5);

  // chat drawer
  static const drawerTitleAtChat =
      GoTextStyle._(fontInfo: FontInfo.nanum, size: 18, weight: _w7);

  static const drawerSubTitleAtChat =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 14, weight: _w7);

  static const drawerTagAtChat = GoTextStyle._(
      fontInfo: FontInfo.nanum,
      size: 13,
      weight: _w7,
      color: GoColors.primaryOrange);

  static const drawerDescriptionAtChat = GoTextStyle._(
      fontInfo: FontInfo.pretend,
      size: 12,
      weight: _w6,
      color: GoColors.secondaryGray);

  // chat bottom sheet
  static const bottomSheetTitleAtChat =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 18, weight: _w6);

  // update dialog
  static const updateDialogTitle =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 18, weight: _w7);

  static const updateDialogDescription =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 14, weight: _w5);

  // leave dialog
  static const leaveDialogTitle =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 18, weight: _w7);

  static const leaveDialogDescription =
      GoTextStyle._(fontInfo: FontInfo.pretend, size: 14, weight: _w5);

  // ---- pre-defined weight ----

  static const double _w5 = 500; // nanum b
  static const double _w6 = 600; // not used with nanum
  static const double _w7 = 700; // nanum eb
  static const double _w8 = 800;

  // ---- private constructor ----

  GoTypos._();
}
