import 'package:flutter/widgets.dart';

import '../kite_theme.dart';
import 'button.dart';

class Dialog extends StatelessWidget {
  const Dialog({required this.child, this.onClose, super.key});

  final Widget child;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: KiteTheme.of(context).background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: KiteTheme.of(context).kagiYellow),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: child),
              Button(onTap: onClose, text: '\u2715', semanticsLabel: 'Close dialog'),
            ],
          ),
        ),
      ),
    );
  }
}
