part of go_design_component;

class LinkButton extends TextBaseButton {
  LinkButton(
    super.text, {
    super.key,
    super.onTap,
    super.padding = const EdgeInsets.all(12),
    bool underline = true,
  }) : super(
          textStyle: GoTypos.linkText(underline: underline),
          color: Colors.transparent,
        );
}
