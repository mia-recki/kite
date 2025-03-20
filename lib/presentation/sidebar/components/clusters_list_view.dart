import 'package:flutter/widgets.dart';

import '../../../data/models/cluster.dart';
import '../../../data/models/content.dart';
import '../../../data/models/history.dart';
import '../../../theme/components/loading_indicator.dart';
import '../../../theme/kite_theme.dart';
import '../../../view_model/actions/intents.dart';
import '../../../view_model/kite_view_model.dart';
import '../../../view_model/provider/kite_provider.dart';
import 'cluster_list_tile.dart';

class ClustersListView extends StatelessWidget {
  const ClustersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: KiteProvider.of<KiteViewModel>(context).currentCategoryContent,
      builder:
          (context, clusters, _) => switch (clusters) {
            (_, []) => Center(
              child: Text(
                'Looks like something went wrong\n¯\\_(ツ)_/¯',
                textAlign: TextAlign.center,
                style: KiteTheme.of(context).errorText,
              ),
            ),
            (final Content? selectedContent, final List<Content> contentList) => ListView(
              padding: EdgeInsets.zero,
              children:
                  contentList
                      .map(
                        (content) => DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: content == selectedContent ? KiteTheme.of(context).focusedItemBackground : null,
                          ),
                          child: GestureDetector(
                            onTap: Actions.handler(context, SelectContentIntent(content)),
                            child: switch (content) {
                              final Cluster cluster => ClusterListTile(cluster, isSelected: cluster == selectedContent),
                              History() => const Padding(padding: EdgeInsets.all(8), child: Text('Today')),
                              _ => const SizedBox.shrink(),
                            },
                          ),
                        ),
                      )
                      .toList(),
            ),
            _ => const Center(child: LoadingIndicator()),
          },
    );
  }
}
