import 'package:flutter/widgets.dart';

import 'data/api/api_client.dart';
import 'data/kite_service.dart';
import 'presentation/home_page.dart';
import 'theme/kite_theme.dart';
import 'view_model/actions/shortcut_mapping.dart';
import 'view_model/kite_view_model.dart';
import 'view_model/provider/kite_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final service = KiteService(ApiClient());
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
        ThemeBrightness.light,
        builder: (context) => WidgetsApp(
          textStyle: KiteTheme.of(context).defaultTextStyle,
          shortcuts: appLevelShortcuts,
          actions: appLevelActions(context),
          color: KiteTheme.white,
          debugShowCheckedModeBanner: false,
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
