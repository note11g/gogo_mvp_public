part of go_design_component;

class ToastWidget extends StatelessWidget {
  final String text;

  const ToastWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
          color: GoColors.toastOrange.withOpacity(0.96),
          borderRadius: GoRounds.m.borderRadius,
          boxShadow: [
            BoxShadow(
              color: GoColors.toastOrange.withOpacity(0.32),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Text(text, style: GoTypos.inputText(color: GoColors.white)),
    );
  }
}
