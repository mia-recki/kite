import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'intents.dart';

final appLevelShortcuts = {
  const SingleActivator(LogicalKeyboardKey.keyH): GoRightIntent(),
  const SingleActivator(LogicalKeyboardKey.keyL): GoLeftIntent(),
  const SingleActivator(LogicalKeyboardKey.keyK): GoUpIntent(),
  const SingleActivator(LogicalKeyboardKey.keyJ): GoDownIntent(),
  const SingleActivator(LogicalKeyboardKey.slash): ToggleCategoriesListIntent(),
	const SingleActivator(LogicalKeyboardKey.keyT): ToggleThemeIntent()
};
