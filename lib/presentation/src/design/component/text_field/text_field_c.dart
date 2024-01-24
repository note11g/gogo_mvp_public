part of go_design_component;

/// using at chat.
class TextFieldTypeC extends StatelessWidget {
  final void Function(String)? onChanged;
  final String hint;
  final TextEditingController? controller;

  const TextFieldTypeC({
    super.key,
    this.onChanged,
    required this.hint,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      hint: hint,
      textStyle: GoTypos.inputTextAtChat,
      hintColor: GoColors.secondaryGray,
      textAlign: TextAlign.start,
      padding: const EdgeInsets.symmetric(vertical: 20),
      controller: controller,
      onChange: onChanged,
      minLine: 1,
      maxLine: 3,
    );
  }
}
