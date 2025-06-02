import 'package:flutter/widgets.dart';

import 'components/app_bar.dart';
import 'components/clusters_list_view.dart';
import 'components/current_category_view.dart';

class SidebarView extends StatelessWidget {
  const SidebarView({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      AppBar(),
      Flexible(child: ClustersListView()),
      CurrentCategoryView(),
    ],
  );
}
