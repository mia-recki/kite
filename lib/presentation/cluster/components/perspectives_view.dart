import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../../data/models/cluster.dart';
import '../../../theme/components/rounded_colored_box.dart';
import '../../../theme/components/url_view.dart';
import '../../../theme/kite_theme.dart';

class PerspectivesView extends StatelessWidget {
  const PerspectivesView(this.perspectives, {super.key});
  final List<Perspective> perspectives;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          for (final perspective in perspectives)
            ConstrainedBox(
              // TODO: render them all the same size
              constraints: BoxConstraints(maxWidth: min(MediaQuery.sizeOf(context).width / 2, 250.0)),
              child: RoundedColoredBox(
                color: KiteTheme.of(context).textBoxBg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    Text(perspective.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(perspective.text),
                    UrlView(perspective.sources.first.url, displayText: perspective.sources.first.name),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
