import 'package:flutter/widgets.dart';

class MouseHoverRegion extends StatefulWidget {
  const MouseHoverRegion({required this.builder, this.onHover, this.cursor = SystemMouseCursors.click, super.key});

  final Widget Function(BuildContext context, bool isHovering) builder;
  final MouseCursor cursor;
  final VoidCallback? onHover;

  @override
  State<MouseHoverRegion> createState() => _MouseHoverRegionState();
}

class _MouseHoverRegionState extends State<MouseHoverRegion> {
  var _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() => _isHovering = true);
        widget.onHover?.call();
      },
      onExit: (e) => setState(() => _isHovering = false),
      cursor: widget.cursor,
      child: widget.builder(context, _isHovering),
    );
  }
}
