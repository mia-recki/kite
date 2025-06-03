import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../../data/models/cluster.dart';
import '../../../theme/components/header_text.dart';

class SourcesGrid extends StatelessWidget {
  const SourcesGrid(this.sources, {super.key});
  final Map<Domain, List<Article>> sources;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderText('Sources'),
        Wrap(children: sources.entries.map((entry) => _SourceView(entry.key, entry.value)).toList()),
      ],
    );
  }
}

class _SourceView extends StatelessWidget {
  const _SourceView(this.domain, this.articles);
  final Domain domain;
  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: preview articles on tap
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: min(MediaQuery.sizeOf(context).width / 3, 160)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  if (domain.favicon.isNotEmpty)
                    Image.network(
                      domain.favicon,
                      width: 16,
                      height: 16,
                      webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                    ),
                  Flexible(child: Text(domain.name)),
                ],
              ),
              Text('${articles.length} articles'),
            ],
          ),
        ),
      ),
    );
  }
}
