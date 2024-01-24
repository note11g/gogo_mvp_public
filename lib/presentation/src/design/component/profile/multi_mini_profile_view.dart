part of go_design_component;

class MultiMiniProfilesView extends StatelessWidget {
  final List<MiniProfileView> profileViews;
  final int rowCount;

  const MultiMiniProfilesView({
    super.key,
    required this.profileViews,
    this.rowCount = 3,
  }) : assert(rowCount >= 2);

  @override
  Widget build(BuildContext context) {
    Row rowMaker(List<MiniProfileView> children) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children:
        (children.length == rowCount ? children : [...children, _mock()])
            .map((w) => Expanded(child: w))
            .toList());

    List<Row> rows = [];

    for (int i = 0; i < profileViews.length; i += rowCount) {
      final count = profileViews.length - i >= rowCount
          ? rowCount
          : profileViews.length - i;
      rows.add(rowMaker(profileViews.sublist(i, i + count)));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }

  _mock() => Container();
}
