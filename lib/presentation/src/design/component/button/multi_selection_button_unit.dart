part of go_design_component;

class MultiSelectionButtonUnit extends StatefulWidget {
  final List<String> texts;
  final void Function(List<String> newList)? onChanged;
  final List<String>? selected;
  final bool multiSelectionEnable;
  final bool multiline;
  final double spacing;
  final double verticalSpacing;
  final EdgeInsets margin;
  final bool showOrdering;

  const MultiSelectionButtonUnit({
    super.key,
    required this.texts,
    this.onChanged,
    this.selected,
    this.multiSelectionEnable = true,
    this.multiline = true,
    this.margin = EdgeInsets.zero,
    this.spacing = 8,
    this.verticalSpacing = 8,
    this.showOrdering = false,
  });

  @override
  State<MultiSelectionButtonUnit> createState() =>
      _MultiSelectionButtonUnitState();
}

class _MultiSelectionButtonUnitState extends State<MultiSelectionButtonUnit> {
  final List<String> selectedTexts = [];

  @override
  Widget build(BuildContext context) {
    if (widget.selected != null) {
      selectedTexts.clear();
      selectedTexts.addAll(widget.selected!);
    }

    final children = widget.texts.map((text) {
      final selected = selectedTexts.contains(text);

      if (widget.showOrdering) {
        final selectedOrderNumber = selectedTexts.indexOf(text) + 1;
        return OrderingMultiSelectionButton(text,
            orderNumber: selectedOrderNumber == 0 ? null : selectedOrderNumber,
            selected: selected,
            onTap: (text, orderNumber) => _onUpdate(text, isAdd: !selected));
      }

      return MultiSelectionButton(text,
          selected: selected, onTap: () => _onUpdate(text, isAdd: !selected));
    }).toList();

    return Padding(
      padding: widget.margin,
      child: widget.multiline
          ? Wrap(
              alignment: WrapAlignment.center,
              spacing: widget.spacing,
              runSpacing: widget.verticalSpacing,
              children: children,
            )
          : GoRow(spacing: widget.spacing, children: children),
    );
  }

  void _onUpdate(String text, {required bool isAdd}) {
    if (widget.multiSelectionEnable) {
      _multiSelect(text, isAdd: isAdd);
    } else {
      _singleSelect(text);
    }
    widget.onChanged?.call(selectedTexts);
    setState(() {});
  }

  void _multiSelect(String text, {required bool isAdd}) {
    if (isAdd) {
      selectedTexts.add(text);
    } else {
      selectedTexts.remove(text);
    }
  }

  void _singleSelect(String text) {
    final alreadySelected = selectedTexts.contains(text);
    selectedTexts.clear();
    if (!alreadySelected) selectedTexts.add(text);
  }
}
