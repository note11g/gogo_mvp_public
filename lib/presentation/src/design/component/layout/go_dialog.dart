part of go_design_component;

class GoDialog extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const GoDialog({
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(16),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: GoRounds.l.borderRadius),
        backgroundColor: GoColors.backgroundGray,
        surfaceTintColor: GoColors.backgroundGray,
        insetPadding: margin,
        child: Container(
          width: double.infinity,
          padding: padding,
          child: child,
        ));
  }
}
