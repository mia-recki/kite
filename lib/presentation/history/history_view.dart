import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/history.dart';
import '../../theme/components/section_view.dart';
import '../../theme/kite_theme.dart';

class HistoryView extends StatelessWidget {
  const HistoryView(this.history, {super.key});
  final History history;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SectionView('Events', child: _TimelineView(history.events)),
        SectionView('People', child: _TimelineView(history.people)),
      ],
    );
  }
}

class _TimelineView extends StatelessWidget {
  const _TimelineView(this.items);
  final List<HistoryItem> items;

  @override
  Widget build(BuildContext context) {
    final accentColor = KiteTheme.of(context).timelineAccentColor;
    return Column(
      children:
          items
              .mapIndexed(
                (i, e) => IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      // Timeline column (dot + line)
                      Column(
                        children: [
                          if (i != 0)
                            SizedBox(height: 8, child: ColoredBox(color: accentColor, child: const SizedBox(width: 3))),
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
                          ),
                          if (i != items.length - 1)
                            Expanded(
                              child: ColoredBox(
                                color: KiteTheme.of(context).timelineAccentColor,
                                child: const SizedBox(width: 3),
                              ),
                            ),
                        ],
                      ),

                      Text(e.year, style: KiteTheme.of(context).headerTextStyle.copyWith(color: accentColor)),
                      // Content
                      Flexible(
                        child: Html(
                          data: e.content,

                          onLinkTap: (src, _, _) {
                            if (src != null) launchUrl(Uri.parse(src));
                          },
                          style: {
                            'a': Style(
                              textDecoration: TextDecoration.underline,
                              color: KiteTheme.of(context).textColor,
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}
