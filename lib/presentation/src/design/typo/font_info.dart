part of go_design_typo;

enum FontInfo {
  nanum('NanumSquareNeo'), pretend('Pretendard');

  const FontInfo(this.fontFamily);

  final String fontFamily;
}
