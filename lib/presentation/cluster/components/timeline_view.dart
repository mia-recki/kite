import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/kite_theme.dart';

typedef TimelineItem = (String date, String content);

class TimelineView extends StatelessWidget {
  const TimelineView(this.items, {super.key});
  final List<TimelineItem> items;

  @override
  Widget build(BuildContext context) {
    final accentColor = KiteTheme.of(context).timelineAccentColor;
    return Column(
      children: items
          .mapIndexed(
            (i, e) => IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  Column(
                    children: [
                      if (i != 0)
                        SizedBox(
                          height: 8,
                          child: ColoredBox(color: accentColor, child: const SizedBox(width: 3)),
                        ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      width: 100,
                      child: Text(
                        e.$1,
                        style: KiteTheme.of(context).headerTextStyle.copyWith(color: accentColor),
                      ),
                    ),
                  ),
                  // Content
                  Flexible(
                    child: Html(
                      data: e.$2,
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
