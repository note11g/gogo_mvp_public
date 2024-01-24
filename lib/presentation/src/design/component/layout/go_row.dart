part of go_design_component;

class GoRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  const GoRow({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resultChildren = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      resultChildren.add(children[i]);
      if (i != children.length - 1) {
        resultChildren.add(SizedBox(width: spacing));
      }
    }

    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: resultChildren,
    );
  }
}
