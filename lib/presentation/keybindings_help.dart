import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../theme/components/header_text.dart';
import '../theme/kite_theme.dart';
import '../utils/screen_utils.dart';

class KeybindingsHelpView extends StatelessWidget {
  const KeybindingsHelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: max(screenSizeBreakpoint, MediaQuery.sizeOf(context).width / 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          const HeaderText('Keybindings'),
          Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FixedColumnWidth(16),
              2: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _row('Select previous/next category', activators: ['h', 'l']),
              _row('Select previous/next article', activators: ['j', 'k']),
              _row('Toggle search for articles', activators: ['/']),
              _row('Toggle theme (light/dark)', activators: ['t']),
              _row('Unselect content (go back)', activators: ['⌘ ]', '⌥ Left'], separator: ','),
              _row('Scroll up/down in an article', activators: ['Up', 'Down']),
              _row('Scroll to the top of the current article', activators: ['g']),
              _row('Scroll to the bottom of the current article', activators: ['G']),
              _row('Toggle keybindings help', activators: ['?']),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _row(String description, {required List<String> activators, String separator = '/'}) {
    final keys = <Widget>[];
    final iterator = activators.iterator;
    if (iterator.moveNext()) {
      keys.add(_KeyView(iterator.current));
      while (iterator.moveNext()) {
        keys.add(Text(separator));
        keys.add(_KeyView(iterator.current));
      }
    }

    return TableRow(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: keys.toList()),
        const SizedBox(width: 16),
        Text(description),
      ],
    );
  }
}

class _KeyView extends StatelessWidget {
  const _KeyView(this.activator);

  final String activator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: KiteTheme.of(context).kagiYellow,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(activator, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
