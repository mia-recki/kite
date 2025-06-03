import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/kite_theme.dart';
import '../kite_view_model.dart';
import '../provider/kite_provider.dart';
import 'actions.dart';
import 'intents.dart';

const appLevelShortcuts = {
  SingleActivator(LogicalKeyboardKey.keyH): GoRightIntent(),
  SingleActivator(LogicalKeyboardKey.keyL): GoLeftIntent(),
  SingleActivator(LogicalKeyboardKey.keyK): GoUpIntent(),
  SingleActivator(LogicalKeyboardKey.keyJ): GoDownIntent(),
  SingleActivator(LogicalKeyboardKey.slash): ToggleCategoriesListIntent(),
  SingleActivator(LogicalKeyboardKey.keyT): ToggleThemeIntent(),
  SingleActivator(LogicalKeyboardKey.bracketLeft, meta: true): GoBackIntent(),
  SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true): GoBackIntent(),
  SingleActivator(LogicalKeyboardKey.escape): EscapeIntent(),
  SingleActivator(LogicalKeyboardKey.arrowUp): ScrollUpIntent(),
  SingleActivator(LogicalKeyboardKey.arrowDown): ScrollDownIntent(),
  SingleActivator(LogicalKeyboardKey.keyG): ScrollToTopIntent(),
  SingleActivator(LogicalKeyboardKey.keyG, shift: true): ScrollToBottomIntent(),
  CharacterActivator('?'): ToggleKeybindingsHelpIntent(),

  if (kDebugMode) SingleActivator(LogicalKeyboardKey.keyD): DebugIntent(),
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
    ToggleKeybindingsHelpIntent: ToggleKeybindingsHelpAction(viewModel),

    if (kDebugMode)
      DebugIntent: CallbackAction(
        onInvoke: (_) {
          debugDumpFocusTree();
          return null;
        },
      ),
  };
}
