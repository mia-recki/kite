import 'package:flutter/widgets.dart';

class BackGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onBackGesture;
  final double edgeWidth;

  const BackGestureDetector({required this.child, required this.onBackGesture, this.edgeWidth = 60.0, super.key});

  @override
  State<BackGestureDetector> createState() => _BackGestureDetectorState();
}

class _BackGestureDetectorState extends State<BackGestureDetector> {
  var _isBackGesture = false;
  var _dragDistance = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) => _isBackGesture = details.localPosition.dx < widget.edgeWidth,
      onHorizontalDragUpdate: (details) => _dragDistance += details.primaryDelta ?? 0,
      onHorizontalDragEnd: (details) {
        if (!_isBackGesture) return;
        if (_dragDistance > 120) widget.onBackGesture?.call();
        _isBackGesture = false;
        _dragDistance = 0;
      },
      child: widget.child,
    );
  }
}
