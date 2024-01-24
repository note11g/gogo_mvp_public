part of go_design_component;

class TextFieldFocusOutHelper extends StatelessWidget {
  final Widget child;

  const TextFieldFocusOutHelper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _unFocus(context),
      child: child,
    );
  }

  void _unFocus(BuildContext context) {
    final scope = FocusScope.of(context);
    final tempFocusNode = FocusNode();
    scope.requestFocus(tempFocusNode);
    tempFocusNode
      ..unfocus()
      ..dispose();
  }
}
