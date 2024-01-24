part of go_design_component;

class FullCTAButton extends BaseCTAButton {
  FullCTAButton(
    super.text, {
    super.key,
    super.enable,
    super.onTap,
    super.onDisabledTap,
    super.margin = const EdgeInsets.all(24),
  }) : super(
          textStyle: GoTypos.fullCTAButtonText(),
          fillWidth: true,
        );
}
