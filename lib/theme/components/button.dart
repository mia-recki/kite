import 'package:flutter/widgets.dart';

import '../kite_theme.dart';
import 'mouse_hover_region.dart';

class Button extends StatelessWidget {
  const Button({required this.onTap, required this.text, this.semanticsLabel, super.key});
  final String text;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: MouseHoverRegion(
        builder: (context, isHovering) {
          return GestureDetector(
            onTap: onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: KiteTheme.of(context).kagiYellow,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Text(text, style: TextStyle(decoration: isHovering ? TextDecoration.underline : null)),
              ),
            ),
          );
        },
      ),
    );
  }
}
