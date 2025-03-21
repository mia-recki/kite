import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/kite_theme.dart';
import '../kite_view_model.dart';
import '../provider/kite_provider.dart';
import 'actions.dart';
import 'intents.dart';

final appLevelShortcuts = {
  const SingleActivator(LogicalKeyboardKey.keyH): GoRightIntent(),
  const SingleActivator(LogicalKeyboardKey.keyL): GoLeftIntent(),
  const SingleActivator(LogicalKeyboardKey.keyK): GoUpIntent(),
  const SingleActivator(LogicalKeyboardKey.keyJ): GoDownIntent(),
  const SingleActivator(LogicalKeyboardKey.slash): ToggleCategoriesListIntent(),
  const SingleActivator(LogicalKeyboardKey.keyT): ToggleThemeIntent(),
  const SingleActivator(LogicalKeyboardKey.bracketLeft, meta: true): GoBackIntent(),
};

Map<Type, Action> appLevelActions(BuildContext context) {
  final viewModel = KiteProvider.of<KiteViewModel>(context);
  return {
    VoidCallbackIntent: VoidCallbackAction(),
    GoRightIntent: SelectNextCategoryAction(viewModel),
    GoLeftIntent: SelectPreviousCategoryAction(viewModel),
    GoDownIntent: SelectNextClusterAction(viewModel),
    GoUpIntent: SelectPreviousClusterAction(viewModel),
    ToggleCategoriesListIntent: ShowCategoriesListAction(viewModel),
    SelectCategoryIntent: SelectCategoryAction(viewModel),
    SelectContentIntent: SelectContentAction(viewModel),
    GoBackIntent: DeselectClusterAction(viewModel),
    ToggleThemeIntent: CallbackAction<ToggleThemeIntent>(onInvoke: (intent) => KiteTheme.toggleTheme(context)),
  };
}
