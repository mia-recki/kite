import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/cluster.dart';
import '../../../theme/components/mouse_hover_region.dart';
import '../../../theme/components/url_view.dart';
import '../../../theme/kite_theme.dart';
import '../../../utils/screen_utils.dart';

class ArticleView extends StatelessWidget {
  const ArticleView(this.article, {super.key});
  final Article article;

  @override
  Widget build(BuildContext context) {
    final displayText = '🔗 ${article.title}';
    return MouseHoverRegion(
      builder: (context, isHovering) {
        return GestureDetector(
          onTap: () => launchUrl(Uri.parse(article.link)),
          child: article.imageUrl == null
              ? UrlView(article.link, displayText: displayText)
              : Semantics(
                  link: true,
                  label: displayText,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.network(
                              article.imageUrl!,
                              frameBuilder: (context, child, frame, _) {
                                return AnimatedSize(
                                  duration: const Duration(milliseconds: 200),
                                  alignment: Alignment.topCenter,
                                  child: frame == 0
                                      ? child
                                      : SvgPicture.asset(
                                          'assets/img/image-placeholder.svg',
                                          fit: BoxFit.contain,
                                          width: screenSizeBreakpoint,
                                        ),
                                );
                              },
                              errorBuilder: (context, _, stackTrace) => SizedBox(
                                width: screenSizeBreakpoint,
                                height: 60, // to fit the link text
                                child: Text(
                                  'Failed to load image',
                                  style: KiteTheme.of(context).errorText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: KiteTheme.black.withAlpha(125),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    article.domain,
                                    style: TextStyle(
                                      color: KiteTheme.white,
                                      decoration: isHovering ? TextDecoration.underline : null,
                                      decorationColor: KiteTheme.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(article.imageCaption ?? '', style: const TextStyle(fontWeight: FontWeight.w200)),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
