import 'package:flutter/widgets.dart';

import '../../../data/models/cluster.dart';
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
      valueListenable: KiteProvider.of<KiteViewModel>(context).currentCategoryClusters,
      builder:
          (context, clusters, _) => switch (clusters) {
            (_, []) => Center(
              child: Text(
                'Looks like something went wrong\n¯\\_(ツ)_/¯',
                textAlign: TextAlign.center,
                style: KiteTheme.of(context).errorText,
              ),
            ),
            (final Cluster? selectedCluster, final List<Cluster> clusters) => ListView(
              padding: EdgeInsets.zero,
              children:
                  clusters
                      .map(
                        (cluster) => GestureDetector(
                          onTap: Actions.handler(context, SelectClusterIntent(cluster)),
                          child: ClusterListTile(cluster, isSelected: cluster == selectedCluster),
                        ),
                      )
                      .toList(),
            ),
            _ => const Center(child: LoadingIndicator()),
          },
    );
  }
}
