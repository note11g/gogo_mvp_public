part of go_design_component;

class TextBaseButton extends RawButton {
  TextBaseButton(
    String text, {
    super.key,
    super.onTap,
    super.color = GoColors.primaryOrange,
    super.rounds = GoRounds.m,
    super.padding = const EdgeInsets.all(18),
    super.fillWidth,
    super.margin,
    required TextStyle textStyle,
  }) : super(child: Text(text, style: textStyle, textAlign: TextAlign.center));
}
