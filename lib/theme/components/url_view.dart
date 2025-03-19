import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../kite_theme.dart';
import 'mouse_hover_region.dart';

class UrlView extends StatelessWidget {
  const UrlView(this.url, {String? displayText, super.key}) : displayText = displayText ?? url;

  final String displayText;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = KiteTheme.of(context);
    return Semantics(
      link: true,
      label: displayText,
      child: MouseHoverRegion(
        builder:
            (context, isHovering) => GestureDetector(
              child: Text(
                displayText,
                style: TextStyle(
                  color: theme.inlineUrlColor,
                  decoration: isHovering ? TextDecoration.underline : null,
                  decorationColor: theme.inlineUrlColor,
                ),
              ),
              onTap: () => launchUrl(Uri.parse(url)),
            ),
      ),
    );
  }
}
