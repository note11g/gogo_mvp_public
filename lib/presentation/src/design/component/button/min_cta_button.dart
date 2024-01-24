part of go_design_component;

class MinCTAButton extends BaseCTAButton {
  MinCTAButton(
    super.text, {
    super.key,
    super.enable,
    super.onTap,
    super.onDisabledTap,
  }) : super(
          textStyle: GoTypos.minCTAButtonText(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        );
}
