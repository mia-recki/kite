import 'package:flutter/widgets.dart';

import '../../data/models/category.dart';
import '../../data/models/content.dart';

class GoUpIntent extends Intent {
  const GoUpIntent();
}

class GoDownIntent extends Intent {
  const GoDownIntent();
}

class GoLeftIntent extends Intent {
  const GoLeftIntent();
}

class GoRightIntent extends Intent {
  const GoRightIntent();
}

class SelectCategoryIntent extends Intent {
  final Category? category;

  const SelectCategoryIntent(this.category);
}

class SelectContentIntent extends Intent {
  final Content? content;

  const SelectContentIntent(this.content);
}

class ToggleCategoriesListIntent extends Intent {
  const ToggleCategoriesListIntent();
}

class ToggleThemeIntent extends Intent {
  const ToggleThemeIntent();
}

class GoBackIntent extends Intent {
  const GoBackIntent();
}

class EscapeIntent extends Intent {
  const EscapeIntent();
}

class ScrollUpIntent extends Intent {
  const ScrollUpIntent();
}

class ScrollDownIntent extends Intent {
  const ScrollDownIntent();
}

class DebugIntent extends Intent {
  const DebugIntent();
}

class ScrollToTopIntent extends Intent {
  const ScrollToTopIntent();
}

class ScrollToBottomIntent extends Intent {
  const ScrollToBottomIntent();
}
