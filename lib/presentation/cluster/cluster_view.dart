import 'package:flutter/widgets.dart';

import '../../data/models/cluster.dart';
import '../../theme/components/category_view.dart';
import '../../theme/components/header_text.dart';
import '../../theme/components/rounded_colored_box.dart';
import '../../theme/components/section_view.dart';
import '../../theme/kite_theme.dart';
import '../../utils/string_utils.dart';
import '../../view_model/actions/intents.dart';
import 'components/article_view.dart';
import 'components/perspectives_view.dart';
import 'components/quote_view.dart';
import 'components/sources_grid.dart';
import 'components/talking_points_view.dart';
import 'components/timeline_view.dart';
import 'defined_section.dart';

class ClusterView extends StatefulWidget {
  const ClusterView(this.cluster, {super.key});
  final Cluster cluster;

  @override
  State<ClusterView> createState() => _ClusterViewState();
}

class _ClusterViewState extends State<ClusterView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Actions(
    actions: {
      ScrollUpIntent: CallbackAction<ScrollUpIntent>(onInvoke: (_) => _scrollController.scrollUp()),
      ScrollDownIntent: CallbackAction<ScrollDownIntent>(onInvoke: (_) => _scrollController.scrollDown()),
      ScrollToTopIntent: CallbackAction<ScrollToTopIntent>(onInvoke: (_) => _scrollController.scrollToTop()),
      ScrollToBottomIntent: CallbackAction<ScrollToBottomIntent>(onInvoke: (_) => _scrollController.scrollToBottom()),
    },
    child: Focus(
      debugLabel: 'ClusterView',
      autofocus: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: MediaQuery.viewPaddingOf(context) + const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: Column(
          spacing: 24,
          children: [
            // category + title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryView(widget.cluster.category),
                Text(
                  widget.cluster.title,
                  maxLines: 4,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                ),
              ],
            ),

            // dynamic fields
            for (final definedSection in defaultSectionsOrder)
              switch (definedSection) {
                DefinedSection.summary => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(definedSection.getSection(widget.cluster)?.text ?? ''),
                    if (widget.cluster.location case final String location)
                      Text('📍 $location', style: const TextStyle(fontWeight: FontWeight.w200)),
                  ],
                ),

                DefinedSection.primaryArticle => _ifPresent(
                  widget.cluster.articles.firstOrNull,
                  (article) => ArticleView(article),
                ),

                DefinedSection.highlights => _ifPresent(
                  definedSection.getPointsSection(widget.cluster),
                  (section) => TalkingPointsView(
                    definedSection.title,
                    section.points.map((point) => point.colonSplit).toList(),
                  ),
                ),

                DefinedSection.quote => _ifPresent(widget.cluster.quote, (quote) => QuoteView(quote)),

                DefinedSection.secondaryArticle =>
                  widget.cluster.articles.length > 1 ? ArticleView(widget.cluster.articles[1]) : null,

                DefinedSection.perspectives => _ifPresent(
                  widget.cluster.perspectives,
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
                  widget.cluster.getSection(definedSection.key),
                  (section) => SectionView(definedSection.title, child: Text(section.text)),
                ),

                DefinedSection.internationalReactions => _ifPresent(
                  definedSection.getPointsSection(widget.cluster),
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
                              color: KiteTheme.of(context).textBoxBg,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(text),
                                ],
                              ),
                            ),
                          );
                        }(),
                    ],
                  ),
                ),

                DefinedSection.timeline => _ifPresent(
                  definedSection.getPointsSection(widget.cluster),
                  (timeline) => SectionView(
                    definedSection.title,
                    child: TimelineView(timeline.points.map((point) => point.splitOnFirst('::')).toList()),
                  ),
                ),

                DefinedSection.sources => SourcesGrid(widget.cluster.articlesByDomain),

                DefinedSection.userActionItems => _ifPresent(
                  definedSection.getSection(widget.cluster),
                  (userActionItems) => RoundedColoredBox(
                    color: KiteTheme.of(context).actionItemsBg,
                    child: SectionView(definedSection.title, child: Text(userActionItems.text)),
                  ),
                ),

                DefinedSection.didYouKnow => _ifPresent(
                  definedSection.getSection(widget.cluster),
                  (didYouKnowSection) => RoundedColoredBox(
                    color: KiteTheme.of(context).didYouKnowBg,
                    child: SectionView(definedSection.title, child: Text(didYouKnowSection.text)),
                  ),
                ),
              },
          ].whereType<Widget>().toList(),
        ),
      ),
    ),
  );

  Widget? _ifPresent<T>(T? value, Widget Function(T) builder) {
    if (value != null) return builder(value);
    return null;
  }
}

extension on ScrollController {
  static const scrollOffset = 250;
  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeOutCubic;

  void scrollUp() => animateTo(offset - scrollOffset, duration: duration, curve: curve);

  void scrollDown() => animateTo(offset + scrollOffset, duration: duration, curve: curve);

  void scrollToBottom() => animateTo(position.maxScrollExtent, duration: duration, curve: curve);

  void scrollToTop() => animateTo(0, duration: duration, curve: curve);
}
