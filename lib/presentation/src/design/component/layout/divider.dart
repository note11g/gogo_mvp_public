part of go_design_component;

class GoDivider extends StatelessWidget {
  final double horizontalMargin;
  final double verticalMargin;

  const GoDivider({
    super.key,
    this.horizontalMargin = 0,
    this.verticalMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      color: GoColors.dividerGray,
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin, vertical: verticalMargin),
    );
  }
}
