import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/data/models/category.dart';
import 'package:kite/data/models/cluster.dart';
import 'package:kite/data/models/history.dart';
import 'package:kite/presentation/categories_search_view.dart';
import 'package:kite/presentation/cluster/cluster_view.dart';
import 'package:kite/presentation/history/history_view.dart';
import 'package:kite/presentation/home_page.dart';
import 'package:kite/presentation/sidebar/sidebar_view.dart';
import 'package:kite/theme/components/dialog.dart';
import 'package:kite/theme/components/kite_logo.dart';
import 'package:kite/theme/kite_theme.dart';
import 'package:kite/view_model/kite_view_model.dart';
import 'package:kite/view_model/provider/kite_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../view_model/kite_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<KiteViewModel>()])
import 'home_page_test.mocks.dart';

void main() {
  late MockKiteService mockService;
  late MockKiteViewModel viewModel;

  const testCategories = [Category(name: 'Category 1', file: ''), Category(name: 'Category 2', file: '')];

  const testCluster = Cluster(
    quote: null,
    articles: [],
    perspectives: [],
    domains: [],
    sections: [TextSection('title', 'title'), TextSection('category', 'category')],
  );
  const testHistory = History([]);

  Widget createHomePageWithDependencies({required Size screenSize}) {
    return KiteProvider(
      service: mockService,
      viewModel: viewModel,
      child: KiteThemeWrapper(
        ThemeBrightness.light,
        builder: (_) => WidgetsApp(
          color: KiteTheme.white,
          pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
                builder(context),
          ),
          home: MediaQuery(
            data: MediaQueryData(size: screenSize),
            child: const HomePage(),
          ),
        ),
      ),
    );
  }

  setUp(() {
    mockService = MockKiteService();
    when(mockService.getCategories()).thenAnswer((_) async => testCategories);
    viewModel = MockKiteViewModel();

    when(viewModel.currentCategoryContent).thenReturn(ValueNotifier((null, [testCluster])));
    when(viewModel.showingCategoriesList).thenReturn(ValueNotifier(false));
    when(viewModel.currentCategory).thenReturn(ValueNotifier(testCategories.first));
  });

  group('HomePage', () {
    group('for small app window sizes', () {
      testWidgets('only sidebar is visible when no content is selected', (tester) async {
        await tester.binding.setSurfaceSize(const Size(300, 600));
        await tester.pumpWidget(createHomePageWithDependencies(screenSize: const Size(300, 600)));
        await tester.pumpAndSettle();

        // Verify only SidebarView is visible
        expect(find.byType(SidebarView), findsOneWidget);
        expect(find.byType(ClusterView), findsNothing);
        expect(find.byType(HistoryView), findsNothing);
      });

      testWidgets('only content view is visible when content is selected', (tester) async {
        when(viewModel.currentCategoryContent).thenReturn(ValueNotifier((testCluster, [testCluster])));

        await tester.binding.setSurfaceSize(const Size(300, 600));
        await tester.pumpWidget(createHomePageWithDependencies(screenSize: const Size(300, 600)));
        await tester.pumpAndSettle();

        // Verify only SidebarView is visible
        expect(find.byType(SidebarView), findsNothing);
        expect(find.byType(ClusterView), findsOneWidget);
        expect(find.byType(HistoryView), findsNothing);
      });
    });

    group('for large app window sizes', () {
      testWidgets('shows split view on large screens', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        await tester.pumpWidget(createHomePageWithDependencies(screenSize: const Size(1200, 800)));
        await tester.pumpAndSettle();

        expect(find.byType(SidebarView), findsOneWidget);
        // Initially shows logo when no cluster is selected
        expect(find.byType(KiteLogo), findsNWidgets(2)); // second logo is in the AppBar
      });
    });
  });

  group('Categories List Dialog Tests', () {
    setUp(() {
      final notifier = ValueNotifier(false);
      when(viewModel.showingCategoriesList).thenReturn(notifier);
      when(viewModel.toggleCategoriesList()).thenAnswer((_) => notifier.value = !notifier.value);
    });

    testWidgets('shows categories list dialog when toggled', (tester) async {
      await tester.pumpWidget(createHomePageWithDependencies(screenSize: const Size(800, 600)));
      await tester.pumpAndSettle();

      // Initially, dialog should not be visible
      expect(find.byType(CategoriesSearchView), findsNothing);

      // Toggle categories list
      viewModel.toggleCategoriesList();
      await tester.pumpAndSettle();

      // Dialog should now be visible
      expect(find.byType(CategoriesSearchView), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('hides categories list dialog when toggled off', (tester) async {
      await tester.pumpWidget(createHomePageWithDependencies(screenSize: const Size(800, 600)));
      await tester.pumpAndSettle();

      // Show dialog
      viewModel.toggleCategoriesList();
      await tester.pumpAndSettle();
      expect(find.byType(CategoriesSearchView), findsOneWidget);

      // Hide dialog
      viewModel.toggleCategoriesList();
      await tester.pumpAndSettle();
      expect(find.byType(CategoriesSearchView), findsNothing);
    });
  });

  group('content side of split view', () {
    testWidgets('shows KiteLogo when no cluster is selected', (tester) async {
      await tester.pumpWidget(createHomePageWithDependencies(screenSize: const Size(1200, 800)));
      await tester.pumpAndSettle();

      expect(find.byType(KiteLogo), findsNWidgets(2)); // AppBar + content view
      expect(find.byType(ClusterView), findsNothing);
      expect(find.byType(HistoryView), findsNothing);
    });

    testWidgets('shows ClusterView when a Cluster is selected', (tester) async {
      when(viewModel.currentCategoryContent).thenReturn(ValueNotifier((testCluster, [testCluster])));

      await tester.pumpWidget(createHomePageWithDependencies(screenSize: const Size(1200, 800)));
      await tester.pumpAndSettle();

      expect(find.byType(KiteLogo), findsOneWidget); // in AppBar
      expect(find.byType(ClusterView), findsOneWidget);
      expect(find.byType(HistoryView), findsNothing);
    });

    testWidgets('shows HistoryView when a History is selected', (tester) async {
      when(viewModel.currentCategoryContent).thenReturn(ValueNotifier((testHistory, [testCluster])));

      await tester.pumpWidget(createHomePageWithDependencies(screenSize: const Size(1200, 800)));
      await tester.pumpAndSettle();

      expect(find.byType(KiteLogo), findsOneWidget); // in AppBar
      expect(find.byType(ClusterView), findsNothing);
      expect(find.byType(HistoryView), findsOneWidget);
    });
  });
}
