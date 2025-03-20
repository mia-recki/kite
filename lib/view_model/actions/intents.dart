import 'package:flutter/widgets.dart';

import '../../data/models/category.dart';
import '../../data/models/cluster.dart';

class GoUpIntent extends Intent {}

class GoDownIntent extends Intent {}

class GoLeftIntent extends Intent {}

class GoRightIntent extends Intent {}

class SelectCategoryIntent extends Intent {
  final Category? category;

  const SelectCategoryIntent(this.category);
}

class SelectClusterIntent extends Intent {
  final Cluster? cluster;

  const SelectClusterIntent(this.cluster);
}

class ToggleCategoriesListIntent extends Intent {}

class ToggleThemeIntent extends Intent {}

class GoBackIntent extends Intent {}
