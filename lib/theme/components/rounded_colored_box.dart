import 'package:flutter/widgets.dart';

class RoundedColoredBox extends StatelessWidget {
  const RoundedColoredBox({required this.child, required this.color, super.key});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
