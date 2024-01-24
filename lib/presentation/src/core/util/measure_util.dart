import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum MeasureConstraintType {
  /// simulate HorizontalListview (Unlimited width)
  ///
  /// constraints => w, h : infinity
  infinity,

  /// simulate [ConstraintsBox]
  ///
  /// constraints => w, h : screen
  screen,

  /// simulate VerticalListview (Unlimited height)
  ///
  /// constraints => w : screen, h : infinity
  infinityHeight;
}

class MeasureUtil {
  static Size measureWidgetSize(
    Widget widget, {
    required BuildContext context,
    required MeasureConstraintType constraintType,
  }) {
    final view = View.of(context);

    final renderBoundary = RenderRepaintBoundary();
    final renderView = _CustomRenderView(
      view: view,
      configuration: ViewConfiguration(
          size: view.physicalSize, devicePixelRatio: view.devicePixelRatio),
      child: renderBoundary,
    );

    final pipelineOwner = PipelineOwner()..rootNode = renderView;
    renderView.prepareInitialFrame();

    final buildOwner = BuildOwner(focusManager: FocusManager());
    final renderToWidget = RenderObjectToWidgetAdapter(
            container: renderBoundary,
            child: MediaQuery(
                data: MediaQueryData.fromView(view),
                child: Theme(
                    data: Theme.of(context),
                    child: Localizations.override(
                        context: context,
                        child: Directionality(
                            textDirection: TextDirection.ltr, child: widget)))))
        .attachToRenderTree(buildOwner);

    buildOwner
      ..buildScope(renderToWidget)
      ..finalizeTree();

    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();

    final screenSize = view.physicalSize / view.devicePixelRatio;
    final constraints = switch (constraintType) {
      MeasureConstraintType.infinity => const BoxConstraints(),
      MeasureConstraintType.infinityHeight =>
        BoxConstraints(maxWidth: screenSize.width),
      MeasureConstraintType.screen => BoxConstraints(
          maxWidth: screenSize.width, maxHeight: screenSize.height),
    };

    renderView.layout(constraints, parentUsesSize: true);
    renderToWidget.renderObject.layout(constraints, parentUsesSize: true);

    return renderToWidget.renderObject.paintBounds.size;
  }

  MeasureUtil._();
}

class _CustomRenderView extends RenderView {
  _CustomRenderView({
    super.child,
    required super.configuration,
    required super.view,
  });

  @override
  void debugAssertDoesMeetConstraints() {}
}
