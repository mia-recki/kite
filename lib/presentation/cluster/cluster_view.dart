import 'package:flutter/widgets.dart';

import '../../data/models/cluster.dart';
import '../../theme/components/category_view.dart';
import '../../theme/components/header_text.dart';
import '../../theme/components/rounded_colored_box.dart';
import '../../theme/kite_theme.dart';
import '../../utils/string_utils.dart';
import 'components/article_view.dart';
import 'components/perspectives_view.dart';
import 'components/quote_view.dart';
import 'components/sources_grid.dart';
import 'components/talking_points_view.dart';
import 'defined_section.dart';

class ClusterView extends StatelessWidget {
  const ClusterView(this.cluster, {super.key});
  final Cluster cluster;

  @override
  Widget build(BuildContext context) {
    final sections = _buildSections(KiteTheme.of(context));
    // TODO: scroll on arrowUp/arrowDown
    return ListView.separated(
      itemCount: sections.length + 1,
      padding: MediaQuery.viewPaddingOf(context) + const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        // category + title
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoryView(cluster.category),
              Text(cluster.title, maxLines: 4, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
            ],
          );
        }
        // dynamic sections
        return sections[index - 1];
      },
    );
  }

  Widget? _ifPresent<T>(T? value, Widget Function(T) builder) {
    if (value != null) return builder(value);
    return null;
  }

  List<Widget> _buildSections(ThemeData theme) =>
      defaultSectionsOrder
          .map(
            (definedSection) => switch (definedSection) {
              DefinedSection.summary => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(definedSection.getSection(cluster)?.text ?? ''),
                  if (cluster.location case final String location)
                    Text('📍 $location', style: const TextStyle(fontWeight: FontWeight.w200)),
                ],
              ),

              DefinedSection.primaryArticle => _ifPresent(
                cluster.articles.firstOrNull,
                (article) => ArticleView(article),
              ),

              DefinedSection.highlights => _ifPresent(
                definedSection.getPointsSection(cluster),
                (section) =>
                    TalkingPointsView(definedSection.title, section.points.map((point) => point.colonSplit).toList()),
              ),

              DefinedSection.quote => _ifPresent(cluster.quote, (quote) => QuoteView(quote)),

              DefinedSection.secondaryArticle => cluster.articles.length > 1 ? ArticleView(cluster.articles[1]) : null,

              DefinedSection.perspectives => _ifPresent(
                cluster.perspectives,
                (perspectives) => PerspectivesView(perspectives),
              ),

              DefinedSection.historicalBackground ||
              DefinedSection.humanitarianImpact ||
              DefinedSection.technicalDetails ||
              DefinedSection.businessAngleText ||
              DefinedSection.businessAnglePoints ||
              DefinedSection.scientificSignificance ||
              DefinedSection.performanceStatistics ||
              DefinedSection.leagueStanding ||
              DefinedSection.designPrinciples ||
              DefinedSection.userExperienceImpact ||
              DefinedSection.gameplayMechanics ||
              DefinedSection.industryImpact ||
              DefinedSection.travelAdvisory ||
              DefinedSection.technicalSpecifications => _ifPresent(
                cluster.getSection(definedSection.key),
                (section) => TextSectionView(definedSection.title, section.text),
              ),

              DefinedSection.internationalReactions => _ifPresent(
                definedSection.getPointsSection(cluster),
                (internationalReactions) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HeaderText(definedSection.title),
                    for (final reaction in internationalReactions.points)
                      () {
                        final (title, text) = reaction.colonSplit;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: RoundedColoredBox(
                            color: theme.textBoxBg,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(text)],
                            ),
                          ),
                        );
                      }(),
                  ],
                ),
              ),

              // TODO: timeline
              DefinedSection.timeline => const Placeholder(child: Text('timeline')),

              DefinedSection.sources => SourcesGrid(cluster.articlesByDomain),

              DefinedSection.userActionItems => _ifPresent(
                definedSection.getSection(cluster),
                (userActionItems) => RoundedColoredBox(
                  color: theme.actionItemsBg,
                  child: TextSectionView(definedSection.title, userActionItems.text),
                ),
              ),

              DefinedSection.didYouKnow => _ifPresent(
                definedSection.getSection(cluster),
                (didYouKnowSection) => RoundedColoredBox(
                  color: theme.didYouKnowBg,
                  child: TextSectionView(definedSection.title, didYouKnowSection.text),
                ),
              ),
            },
          )
          .whereType<Widget>()
          .toList();
}

class TextSectionView extends StatelessWidget {
  const TextSectionView(this.title, this.content, {super.key});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 12, children: [HeaderText(title), Text(content)]);
}
