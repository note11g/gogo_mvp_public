part of go_design_component;

class TextFieldTypeB extends StatelessWidget {
  final void Function(String)? onChanged;
  final String hint;
  final int maxLength;
  final void Function()? onTap;
  final TextEditingController? controller;

  const TextFieldTypeB({
    super.key,
    this.onChanged,
    required this.hint,
    required this.maxLength,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BaseTextField(
        controller: controller,
        hint: hint,
        textStyle: GoTypos.inputTextAtHome,
        hintColor: GoColors.disabledGray,
        backgroundColor: GoColors.backgroundGray,
        textAlign: TextAlign.start,
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 16),
        maxLength: maxLength,
        onTap: onTap,
        onChange: onChanged,
        maxLine: 1,
      ),
      Container(height: 2, color: GoColors.black),
    ]);
  }
}
