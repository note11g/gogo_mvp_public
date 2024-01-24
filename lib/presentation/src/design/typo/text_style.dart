part of go_design_typo;

class GoTextStyle {
  final FontInfo fontInfo;
  final double size;
  final double weight;
  final Color color;
  final bool underline;

  const GoTextStyle._({
    required this.fontInfo,
    required this.size,
    required this.weight,
    this.color = GoColors.black,
    this.underline = false,
  });

  TextStyle call({
    double? size,
    double? weight,
    Color? color,
    bool? underline,
  }) {
    final textSize = size ?? this.size;
    final textWeight = weight ?? this.weight;
    final textColor = color ?? this.color;
    final enableUnderline = underline ?? this.underline;
    return TextStyle(
        fontFamily: fontInfo.fontFamily,
        fontSize: textSize,
        fontVariations: [FontVariation("wght", textWeight)],
        color: textColor,
        decoration: enableUnderline ? TextDecoration.underline : null,
        decorationColor: enableUnderline ? textColor : null,
    );
  }

  GoTextStyle _copyWith({
    double? size,
    double? weight,
    Color? color,
    bool? underline,
  }) =>
      GoTextStyle._(
        fontInfo: fontInfo,
        size: size ?? this.size,
        weight: weight ?? this.weight,
        color: color ?? this.color,
        underline: underline ?? this.underline,
      );
}
