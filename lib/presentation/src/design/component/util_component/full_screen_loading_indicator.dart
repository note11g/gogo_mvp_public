part of go_design_component;

class FullScreenLoadingIndicator extends StatefulWidget {
  final bool isLoading;

  const FullScreenLoadingIndicator({super.key, required this.isLoading});

  @override
  State<FullScreenLoadingIndicator> createState() =>
      _FullScreenLoadingIndicatorState();
}

class _FullScreenLoadingIndicatorState
    extends State<FullScreenLoadingIndicator> {
  bool get loaded => !widget.isLoading;
  bool animationFinished = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) animationFinished = false;
    return animationFinished ? const SizedBox() : _loadingWidget();
  }

  Widget _loadingWidget() => Positioned.fill(
      child: AnimatedOpacity(
          opacity: widget.isLoading ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          onEnd: () {
            animationFinished = true;
            setState(() {});
          },
          child: Container(
              color: Colors.black38,
              child: const Center(
                  child: CircularProgressIndicator(color: Colors.white)))));
}
