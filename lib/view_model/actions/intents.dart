import 'package:flutter/widgets.dart';

import '../../data/models/category.dart';
import '../../data/models/content.dart';

class GoUpIntent extends Intent {}

class GoDownIntent extends Intent {}

class GoLeftIntent extends Intent {}

class GoRightIntent extends Intent {}

class SelectCategoryIntent extends Intent {
  final Category? category;

  const SelectCategoryIntent(this.category);
}

class SelectContentIntent extends Intent {
  final Content? content;

  const SelectContentIntent(this.content);
}

class ToggleCategoriesListIntent extends Intent {}

class ToggleThemeIntent extends Intent {}

class GoBackIntent extends Intent {}
