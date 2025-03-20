import 'dart:math';

import 'package:flutter/widgets.dart';

import '../data/kite_service.dart';
import '../data/models/cluster.dart';
import '../theme/components/dialog.dart';
import '../theme/components/kite_logo.dart';
import '../theme/kite_theme.dart';
import '../utils/screen_utils.dart';
import '../view_model/actions/intents.dart';
import '../view_model/categories_search_view_model.dart';
import '../view_model/kite_view_model.dart';
import '../view_model/provider/kite_provider.dart';
import 'categories_search_view.dart';
import 'cluster/cluster_view.dart';
import 'sidebar/sidebar_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KiteTheme.of(context);
    return ColoredBox(
      color: theme.background,
      child: ValueListenableBuilder(
        valueListenable: KiteProvider.of<KiteViewModel>(context).showingCategoriesList,
        builder:
            (context, isShowingCategoriesList, _) => Stack(
              alignment: Alignment.center,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSplitView = constraints.maxWidth > screenSizeBreakpoint;

                    return switch (isSplitView) {
                      /// single page view for smaller screens
                      false => ValueListenableBuilder(
                        valueListenable: KiteProvider.of<KiteViewModel>(context).currentCategoryClusters,
                        builder: (context, clusters, _) {
                          return switch (clusters) {
                            (final Cluster selectedCluster, _) => ClusterView(selectedCluster),
                            _ => const SidebarView(),
                          };
                        },
                      ),

                      /// split view for larger screens
                      true => Row(
                        spacing: 16,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: min(500, MediaQuery.sizeOf(context).width / 5 * 2)),
                            child: const SidebarView(),
                          ),
                          Expanded(
                            child: Center(
                              child: ValueListenableBuilder(
                                valueListenable: KiteProvider.of<KiteViewModel>(context).currentCategoryClusters,
                                builder:
                                    (context, value, _) => switch (value.$1) {
                                      final Cluster cluster => ClusterView(cluster, key: ValueKey(cluster)),
                                      null => const KiteLogo(),
                                    },
                              ),
                            ),
                          ),
                        ],
                      ),
                    };
                  },
                ),
                if (isShowingCategoriesList)
                  Positioned(
                    width: min(MediaQuery.sizeOf(context).shortestSide, screenSizeBreakpoint),
                    bottom: MediaQuery.viewInsetsOf(context).bottom,
                    top: MediaQuery.viewInsetsOf(context).top,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Dialog(
                        onClose: Actions.handler(context, ToggleCategoriesListIntent()),
                        child: CategoriesSearchView(CategoriesSearchViewModel(KiteProvider.of<KiteService>(context))),
                      ),
                    ),
                  ),
              ],
            ),
      ),
    );
  }
}
