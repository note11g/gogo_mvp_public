part of go_design_component;

class HalfCTAButton extends BaseCTAButton {
  HalfCTAButton(
    super.text, {
    super.key,
    super.onTap,
    bool secondary = false,
  }) : super(
          onDisabledTap: null,
          textStyle: secondary
              ? GoTypos.halfCTAButtonSecondaryText()
              : GoTypos.halfCTAButtonText(),
          enableColor:
              secondary ? GoColors.secondaryGray : GoColors.primaryOrange,
        );
}
