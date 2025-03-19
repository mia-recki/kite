import 'package:flutter/widgets.dart';

import '../../../data/models/cluster.dart';
import '../../../theme/components/category_view.dart';
import '../../../theme/kite_theme.dart';

class ClusterListTile extends StatelessWidget {
  const ClusterListTile(this.cluster, {this.isSelected = false, super.key});

  final Cluster cluster;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? KiteTheme.of(context).focusedItemBackground : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: constraints,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryView(cluster.category),
                      Text(
                        cluster.title,
                        maxLines: 4,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                        semanticsLabel: 'Title: ${cluster.title}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
