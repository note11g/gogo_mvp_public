part of go_design_component;

class GoSpacer extends StatelessWidget {
  final double size;
  final Axis? axis;

  const GoSpacer(this.size, {super.key, this.axis});

  @override
  Widget build(BuildContext context) {
    if (axis == null) {
      return SizedBox(width: size, height: size);
    } else {
      return SizedBox(
          width: axis == Axis.horizontal ? size : null,
          height: axis == Axis.vertical ? size : null);
    }
  }
}
