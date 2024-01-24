part of go_design_component;

class MultiSelectionButton extends TextBaseButton {
  MultiSelectionButton(
    super.text, {
    super.key,
    super.onTap,
    bool selected = true,
  }) : super(
          color: selected ? GoColors.primaryOrange : GoColors.disabledGray,
          textStyle: GoTypos.multiSelectionButtonText(),
          rounds: GoRounds.circle,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        );
}

class OrderingMultiSelectionButton extends StatelessWidget {
  final String text;
  final int? orderNumber;
  final bool selected;
  final void Function(String text, int? orderNumber)? onTap;

  const OrderingMultiSelectionButton(
    this.text, {
    super.key,
    required this.orderNumber,
    this.onTap,
    required this.selected,
  }) : assert(!selected ||
            orderNumber != null); // selected가 false면, orderNumber가 null이어야 함.

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      MultiSelectionButton(
        text,
        selected: selected,
        onTap: () => onTap?.call(text, orderNumber),
      ),
      if (orderNumber != null)
        Positioned(top: -4, left: -2, child: _orderingBadge()),
    ]);
  }

  Widget _orderingBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: const BoxDecoration(
          color: GoColors.backgroundOrange,
          shape: BoxShape.circle,
        ),
        child: Text(
          orderNumber.toString(),
          style: GoTypos.multiSelectionButtonOrderNumber(),
        ),
      );
}
