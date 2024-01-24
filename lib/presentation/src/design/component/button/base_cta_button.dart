part of go_design_component;

class BaseCTAButton extends TextBaseButton {
  BaseCTAButton(
      super.text, {
        super.key,
        required super.textStyle,
        super.padding,
        super.margin,
        super.fillWidth,
        bool enable = true,
        required void Function()? onTap,
        required void Function()? onDisabledTap,
        Color enableColor = GoColors.primaryOrange,
      }) : super(
    color: enable ? enableColor : GoColors.disabledGray,
    rounds: GoRounds.l,
    onTap: enable ? onTap : onDisabledTap,
  );
}