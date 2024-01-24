part of go_design_component;

enum BalloonNipPosition {
  bottomRight;
}

class Balloon extends StatelessWidget {
  final BalloonNipPosition nipPosition;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final Color color;
  final Color shadowColor;
  final Widget child;
  final double nipMargin;

  const Balloon({
    super.key,
    this.nipPosition = BalloonNipPosition.bottomRight,
    this.nipMargin = 0,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.color = Colors.white,
    this.shadowColor = Colors.black12,
    required this.child,
  });

  BoxShadow get boxShadow =>
      BoxShadow(color: shadowColor, blurRadius: 12, offset: const Offset(0, 2));

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BalloonPainter(
        color: color,
        shadowColor: shadowColor,
        borderRadius: borderRadius,
        nipPosition: nipPosition,
        nipMargin: nipMargin,
        nipSize: 12,
        elevation: 4,
      ),
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _BalloonPainter extends CustomPainter {
  final Color color;
  final Color shadowColor;
  final double elevation;
  final double nipSize;
  final BorderRadius borderRadius;
  final BalloonNipPosition nipPosition;
  final double nipMargin;

  _BalloonPainter({
    required this.color,
    required this.shadowColor,
    required this.elevation,
    required this.nipSize,
    required this.nipMargin,
    required this.borderRadius,
    required this.nipPosition,
  });

  double get nipHeight => nipSize / 2 * math.sqrt(2);

  @override
  void paint(Canvas canvas, Size size) {
    final path = drawPath(size);


    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawShadow(path, shadowColor, elevation, false);
    canvas.drawPath(path, paint);
  }

  Path drawPath(Size size) {
    final topLineX1 = topLeftRadius.x;
    final topLineX2 = size.width - topRightRadius.x;
    final rightLineY1 = topRightRadius.y;
    final rightLineY2 = size.height - bottomRightRadius.y;
    final bottomLineX1 = bottomLeftRadius.x;
    final bottomLineX2 = size.width - bottomRightRadius.x;
    final leftLineY1 = topLeftRadius.y;
    final leftLineY2 = size.height - bottomLeftRadius.y;

    final path = Path();

    // ---------------
    path
      ..moveTo(topLineX1, 0)
      ..lineTo(topLineX2, 0);

    //                ⌍
    //                |
    //                |
    path
      ..arcToPoint(Offset(size.width, rightLineY1), radius: topRightRadius)
      ..lineTo(size.width, rightLineY2);

    // -----------⌵---⌏
    final bottomY = size.height;
    final nipStartX = bottomLineX2 - nipMargin; // right 기준.
    final nipEndX = nipStartX - nipSize;
    final nipWidthCenter = nipSize / 2;
    final nipPoint = Offset(nipStartX - nipWidthCenter, bottomY + nipHeight);

    const nipRound = 2.0;
    final roundWidth = (nipRound * math.sqrt(2) / 2);
    final nipRoundStartPoint =
        Offset(nipPoint.dx + roundWidth, nipPoint.dy - nipRound);
    final nipRoundEndPoint =
        Offset(nipPoint.dx - roundWidth, nipRoundStartPoint.dy);

    path
      ..arcToPoint(Offset(bottomLineX2, bottomY), radius: bottomRightRadius)
      ..lineTo(nipStartX, bottomY)
      ..lineTo(nipRoundStartPoint.dx, nipRoundStartPoint.dy)
      ..arcToPoint(nipRoundEndPoint, radius: const Radius.circular(nipRound))
      ..lineTo(nipEndX, bottomY)
      ..lineTo(bottomLineX1, bottomY);

    // |
    // |
    // ⌞
    path
      ..arcToPoint(Offset(0, leftLineY2), radius: bottomLeftRadius)
      ..lineTo(0, leftLineY1);

    // ⌌ : last arc
    path.arcToPoint(Offset(topLineX1, 0), radius: topLeftRadius);

    return path..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Radius get topLeftRadius => borderRadius.topLeft;

  Radius get topRightRadius => borderRadius.topRight;

  Radius get bottomLeftRadius => borderRadius.bottomLeft;

  Radius get bottomRightRadius => borderRadius.bottomRight;
}
