import 'package:flutter/widgets.dart';

import '../../data/models/category.dart';
import '../../data/models/cluster.dart';
import '../kite_view_model.dart';
import 'intents.dart';

abstract class _KiteAction<T extends Intent> extends Action<T> {
  _KiteAction(this.viewModel);

  final KiteViewModel viewModel;
}

class SelectCategoryAction extends _KiteAction<SelectCategoryIntent> {
  SelectCategoryAction(super.viewModel);

  @override
  Object? invoke(SelectCategoryIntent intent) {
    if (intent.category case final Category category) viewModel.selectCategory(category);
    return null;
  }
}

class SelectNextCategoryAction extends _KiteAction<GoRightIntent> {
  SelectNextCategoryAction(super.viewModel);

  @override
  Object? invoke(Intent intent) {
    viewModel.selectNextCategory();
    return null;
  }
}

class SelectPreviousCategoryAction extends _KiteAction<GoLeftIntent> {
  SelectPreviousCategoryAction(super.viewModel);

  @override
  Object? invoke(Intent intent) {
    viewModel.selectPreviousCategory();
    return null;
  }
}

class SelectNextClusterAction extends _KiteAction {
  SelectNextClusterAction(super.viewModel);

  @override
  Object? invoke(Intent intent) {
    viewModel.selectNextCluster();
    return null;
  }
}

class SelectPreviousClusterAction extends _KiteAction {
  SelectPreviousClusterAction(super.viewModel);

  @override
  Object? invoke(Intent intent) {
    viewModel.selectPreviousCluster();
    return null;
  }
}

class SelectClusterAction extends _KiteAction<SelectClusterIntent> {
  SelectClusterAction(super.viewModel);

  @override
  Object? invoke(SelectClusterIntent intent) {
    if (intent.cluster case final Cluster cluster) {
      viewModel.selectCluster(cluster);
    }
    return null;
  }
}

class DeselectClusterAction extends _KiteAction<GoBackIntent> {
  DeselectClusterAction(super.viewModel);
  @override
  Object? invoke(GoBackIntent intent) {
    viewModel.selectCluster(null);
    return null;
  }
}

class ShowCategoriesListAction extends _KiteAction<ToggleCategoriesListIntent> {
  ShowCategoriesListAction(super.viewModel);

  @override
  Object? invoke(Intent intent) {
    viewModel.toggleCategoriesList();
    return null;
  }
}
