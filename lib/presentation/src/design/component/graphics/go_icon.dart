part of go_design_component;

class GoIcon extends StatelessWidget {
  final double size;
  final String name;
  final Color? color;

  const GoIcon({
    Key? key,
    this.size = 24,
    required this.name,
    this.color,
  }) : super(key: key);

  String get path => 'assets/icons/$name.svg';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
