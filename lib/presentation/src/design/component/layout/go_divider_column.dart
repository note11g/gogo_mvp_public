part of go_design_component;

class GoDivideColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Widget divider;
  final int? excludeIndex;
  final bool includeLast;

  const GoDivideColumn({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.excludeIndex,
    required this.divider,
    required this.children,
    this.includeLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resultChildren = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      resultChildren.add(children[i]);
      if (i != children.length - 1 && i != excludeIndex) {
        resultChildren.add(divider);
      }
    }

    if (includeLast) resultChildren.add(divider);

    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: resultChildren,
    );
  }
}
