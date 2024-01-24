part of go_design_component;

class ProfilePhotoView extends StatelessWidget {
  final String image;
  final void Function()? onTap;
  final double size;

  const ProfilePhotoView({
    super.key,
    required this.image,
    this.onTap,
    this.size = 96,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: Material(
            shape: const SquircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: image.isNotEmpty ? _imageWidget() : _mockContainer(),
            )));
  }

  bool get _isRemote => PhotoUtil.isRemoteUrl(image);

  Widget _imageWidget() => _isRemote
      ? CachedNetworkImage(imageUrl: image, fit: BoxFit.cover)
      : Image.file(File(image), fit: BoxFit.cover);

  Widget _mockContainer() => Container(color: GoColors.disabledGray);
}

class SquircleBorder extends ShapeBorder {
  final BorderSide side;
  final double superRadius;

  const SquircleBorder({
    this.side = BorderSide.none,
    this.superRadius = 5.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) {
    return SquircleBorder(
      side: side.scale(t),
      superRadius: superRadius * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _squirclePath(rect.deflate(side.width), superRadius);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _squirclePath(rect, superRadius);
  }

  static Path _squirclePath(Rect rect, double superRadius) {
    final c = rect.center;
    final dx = c.dx * (1.0 / superRadius);
    final dy = c.dy * (1.0 / superRadius);
    return Path()
      ..moveTo(c.dx, 0.0)
      ..relativeCubicTo(c.dx - dx, 0.0, c.dx, dy, c.dx, c.dy)
      ..relativeCubicTo(0.0, c.dy - dy, -dx, c.dy, -c.dx, c.dy)
      ..relativeCubicTo(-(c.dx - dx), 0.0, -c.dx, -dy, -c.dx, -c.dy)
      ..relativeCubicTo(0.0, -(c.dy - dy), dx, -c.dy, c.dx, -c.dy)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        var path = getOuterPath(rect.deflate(side.width / 2.0),
            textDirection: textDirection);
        canvas.drawPath(path, side.toPaint());
    }
  }
}
