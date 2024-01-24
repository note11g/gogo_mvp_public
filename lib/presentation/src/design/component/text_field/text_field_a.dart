part of go_design_component;

class TextFieldTypeA extends StatelessWidget {
  final void Function(String)? onChanged;
  final String label;
  final String hint;
  final int maxLength;
  final TextEditingController? controller;

  const TextFieldTypeA({
    super.key,
    this.onChanged,
    required this.label,
    required this.hint,
    this.maxLength = 10,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BaseTextField(
        controller: controller,
        hint: hint,
        textStyle: GoTypos.inputText,
        backgroundColor: GoColors.backgroundGray,
        textAlign: TextAlign.end,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        maxLength: maxLength,
        onChange: onChanged,
        maxLine: 1,
      ),
      Positioned(
          top: 0,
          bottom: 0,
          left: 20,
          child: Center(child: Text(label, style: GoTypos.inputLabelText()))),
    ]);
  }
}
