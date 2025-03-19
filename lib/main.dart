import 'package:flutter/widgets.dart';

import 'data/api/dummy_client.dart';
import 'data/kite_service.dart';
import 'presentation/home_page.dart';
import 'theme/kite_theme.dart';
import 'view_model/actions/actions.dart';
import 'view_model/actions/intents.dart';
import 'view_model/actions/shortcut_mapping.dart';
import 'view_model/kite_view_model.dart';
import 'view_model/provider/kite_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final service = KiteService(DummyClient());
  final viewModel = KiteViewModel(service);
  runApp(MainApp(viewModel, service));
}

class MainApp extends StatelessWidget {
  const MainApp(this.viewModel, this.service, {super.key});
  final KiteService service;
  final KiteViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return KiteProvider(
      service: service,
      viewModel: viewModel,
      child: KiteThemeWrapper(
        KiteThemeBrightness.light,
        builder:
            (context) => WidgetsApp(
              textStyle: TextStyle(color: KiteTheme.of(context).textColor),
              //showSemanticsDebugger: true,
              shortcuts: appLevelShortcuts,
              actions: {
                VoidCallbackIntent: VoidCallbackAction(),
                GoRightIntent: SelectNextCategoryAction(viewModel),
                GoLeftIntent: SelectPreviousCategoryAction(viewModel),
                GoDownIntent: SelectNextClusterAction(viewModel),
                GoUpIntent: SelectPreviousClusterAction(viewModel),
                ToggleCategoriesListIntent: ShowCategoriesListAction(viewModel),
                SelectCategoryIntent: SelectCategoryAction(viewModel),
                SelectClusterIntent: SelectClusterAction(viewModel),
                ToggleThemeIntent: CallbackAction<ToggleThemeIntent>(
                  onInvoke: (intent) => KiteTheme.toggleTheme(context),
                ),
              },
              color: const Color(0xFFFFFFFF),
              debugShowCheckedModeBanner: false,
              builder: (context, _) => const Focus(autofocus: true, child: HomePage()),
            ),
      ),
    );
  }
}
