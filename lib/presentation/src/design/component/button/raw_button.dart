part of go_design_component;

class RawButton extends StatelessWidget {
  final void Function()? onTap;
  final Color color;
  final GoRounds rounds;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final bool fillWidth;
  final Widget child;

  const RawButton({
    super.key,
    this.onTap,
    this.color = Colors.transparent,
    this.rounds = GoRounds.m,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.fillWidth = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: fillWidth ? double.infinity : null,
        padding: margin,
        child: Material(
            color: color,
            borderRadius: rounds.borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
                onTap: onTap,
                child: Padding(padding: padding, child: child))));
  }
}
