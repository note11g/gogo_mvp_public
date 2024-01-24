part of go_design_component;

class FadeHorizontalScrollableView extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final double leftFadeWidth;
  final double rightFadeWidth;
  final double horizontalPadding;
  final ScrollController? controller;

  // temp
  final void Function(double width, double maxWidth)? onMeasured;

  const FadeHorizontalScrollableView({
    super.key,
    required this.child,
    required this.backgroundColor,
    this.leftFadeWidth = 12,
    this.rightFadeWidth = 12,
    this.horizontalPadding = 12,
    this.controller,
    this.onMeasured,
  });

  @override
  State<FadeHorizontalScrollableView> createState() =>
      _FadeHorizontalScrollableViewState();
}

class _FadeHorizontalScrollableViewState
    extends State<FadeHorizontalScrollableView> {
  bool markNeedFlex = true;
  bool isMeasured = false;
  double lastMeasuredWidth = -1;

  bool get needFlex => isMeasured ? markNeedFlex : true;

  @override
  Widget build(BuildContext context) {
    final scrollViewChildWidth =
        _measureWidgetWidth(_getChildWithPadding(), context: context);

    if (lastMeasuredWidth != scrollViewChildWidth) {
      lastMeasuredWidth = scrollViewChildWidth;
      isMeasured = false; // need re-measure
    }

    return Expanded(
      flex: needFlex ? 1 : 0,
      child: LayoutBuilder(builder: (context, constraints) {
        if (isMeasured) {
          isMeasured = false;
          widget.onMeasured
              ?.call(scrollViewChildWidth, constraints.maxWidth); // temp
          return _getFadeScrollView(overflowed: markNeedFlex);
        }

        final flexWidth = constraints.maxWidth;
        markNeedFlex = scrollViewChildWidth >= flexWidth;
        isMeasured = true;

        _runAfterBuild(() => setState(() {}));

        return _getFadeScrollView(overflowed: markNeedFlex);
      }),
    );
  }

  Widget _getChildWithPadding() => Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: widget.child,
      );

  Widget _getFadeScrollView({required bool overflowed}) {
    getFadeMask({double fadeAt = 0.72, required bool isLeft}) => ClipRect(
        child: ShaderMask(
            shaderCallback: (rect) => LinearGradient(
                  stops: [0, fadeAt],
                  colors: isLeft
                      ? [Colors.transparent, Colors.black]
                      : [Colors.black, Colors.transparent],
                ).createShader(rect),
            blendMode: BlendMode.dstOut,
            child: Container(
              width: isLeft ? widget.leftFadeWidth : widget.rightFadeWidth,
              color: widget.backgroundColor,
            )));

    return Stack(children: [
      SingleChildScrollView(
        controller: widget.controller,
        physics: overflowed
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: _getChildWithPadding(),
      ),
      if (overflowed)
        Positioned.fill(right: null, child: getFadeMask(isLeft: true)),
      if (overflowed)
        Positioned.fill(left: null, child: getFadeMask(isLeft: false)),
    ]);
  }

  double _measureWidgetWidth(Widget widget, {required BuildContext context}) =>
      MeasureUtil.measureWidgetSize(widget,
              constraintType: MeasureConstraintType.infinity, context: context)
          .width;

  static void _runAfterBuild(Function() callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }
}
