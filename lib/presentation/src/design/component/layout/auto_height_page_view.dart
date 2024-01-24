part of go_design_component;

class AutoHeightPageView extends StatefulWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  final double spacing;
  final void Function(int)? onPageChanged;

  const AutoHeightPageView({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.spacing = 8,
    this.onPageChanged,
  });

  @override
  State<AutoHeightPageView> createState() => _AutoHeightPageViewState();
}

class _AutoHeightPageViewState extends State<AutoHeightPageView> {
  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return const SizedBox();

    final viewportFraction =
        (screenWidth - widget.padding.horizontal) / screenWidth;

    final measuredFirstItemHeight = MeasureUtil.measureWidgetSize(
            widget.children.first,
            context: context,
            constraintType: MeasureConstraintType.infinityHeight)
        .height;

    return SizedBox(
        height: measuredFirstItemHeight + widget.padding.vertical,
        child: PageView(
          onPageChanged: widget.onPageChanged,
          physics: const BouncingScrollPhysics(),
          controller: PageController(viewportFraction: viewportFraction),
          children: widget.children
              .map((e) => Padding(
                  padding: widget.padding.copyWith(
                      left: widget.spacing / 2, right: widget.spacing / 2),
                  child: e))
              .toList(),
        ));
  }

  double get screenWidth => MediaQuery.sizeOf(context).width;

  double get itemWidth => screenWidth - widget.padding.horizontal;
}
