import 'package:flutter/widgets.dart';

import '../../../data/models/cluster.dart';
import '../../../theme/components/rounded_colored_box.dart';
import '../../../theme/components/url_view.dart';
import '../../../theme/kite_theme.dart';

class QuoteView extends StatelessWidget {
  const QuoteView(this.quote, {super.key});
  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return RoundedColoredBox(
      color: KiteTheme.of(context).textBoxBg,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(quote.text),
          UrlView(quote.sourceUrl, displayText: '${quote.author} (via ${quote.sourceDomain})'),
        ],
      ),
    );
  }
}
