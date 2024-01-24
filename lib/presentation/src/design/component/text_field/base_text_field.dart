part of go_design_component;

class BaseTextField extends StatelessWidget {
  final Color? backgroundColor;
  final GoRounds rounds;
  final bool enabled;
  final bool passwordMode;
  final TextEditingController? controller;
  final String? hint;
  final int? maxLength;
  final int? maxLine;
  final int? minLine;
  final GoTextStyle textStyle;
  final TextAlign textAlign;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Function(String)? onAction;
  final Function()? onTap;
  final Function(String)? onChange;
  final EdgeInsets? padding;
  final Color textColor;
  final Color disabledTextColor;
  final Color hintColor;
  final Color cursorColor;
  final FocusNode? focusNode;

  const BaseTextField({
    super.key,
    this.backgroundColor,
    this.rounds = GoRounds.m,
    this.enabled = true,
    this.passwordMode = false,
    this.controller,
    this.hint,
    this.maxLength,
    this.maxLine,
    this.minLine,
    this.textInputType,
    this.textInputAction,
    this.onAction,
    this.onTap,
    this.onChange,
    required this.textStyle,
    this.textAlign = TextAlign.start,
    this.padding,
    this.textColor = GoColors.black,
    this.disabledTextColor = GoColors.disabledGray,
    this.hintColor = GoColors.dividerGray,
    this.cursorColor = GoColors.primaryOrange,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: rounds.borderRadius),
        child: TextField(
          style: textStyle(color: enabled ? textColor : disabledTextColor),
          enabled: enabled,
          obscureText: passwordMode,
          controller: controller,
          textAlign: textAlign,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: textStyle.call(color: hintColor),
              border: InputBorder.none,
              isDense: true,
              contentPadding: padding,
              counterText: ""),
          maxLength: maxLength,
          maxLines: maxLine,
          minLines: minLine,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          onSubmitted: onAction,
          cursorColor: cursorColor,
          onTap: onTap,
          onChanged: onChange,
          focusNode: focusNode,
        ));
  }
}
