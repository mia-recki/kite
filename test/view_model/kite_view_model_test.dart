import 'package:flutter_test/flutter_test.dart';
import 'package:kite/data/kite_service.dart';
import 'package:kite/data/models/category.dart';
import 'package:kite/data/models/cluster.dart';
import 'package:kite/data/models/history.dart';
import 'package:kite/view_model/kite_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<KiteService>()])
import 'kite_view_model_test.mocks.dart';

void main() {
  late MockKiteService mockService;
  late KiteViewModel viewModel;

  const testCategories = [
    Category(name: 'Category 0', file: ''),
    Category(name: 'Category 1', file: ''),
    Category(name: 'Category 2', file: ''),
  ];

  const testContent = [
    Cluster(quote: null, articles: [], perspectives: [], domains: [], sections: []),
    Cluster(quote: null, articles: [], perspectives: [], domains: [], sections: []),
    History([]),
    Cluster(quote: null, articles: [], perspectives: [], domains: [], sections: []),
  ];

  setUp(() {
    mockService = MockKiteService();
    when(mockService.getCategories()).thenAnswer((_) async => testCategories);
    when(mockService.getCategoryContentFor(any)).thenAnswer((_) async => testContent);
  });

  test('initializes with first category and its content', () async {
    viewModel = KiteViewModel(mockService);

    await Future.delayed(Duration.zero); // wait for initialization

    expect(viewModel.currentCategory.value, equals(testCategories.first));
    expect(viewModel.currentCategoryContent.value.$1, isNull);
    expect(viewModel.currentCategoryContent.value.$2, equals(testContent));
  });

  group('category navigation', () {
    setUp(() async {
      viewModel = KiteViewModel(mockService);
      await Future.delayed(Duration.zero); // wait for initialization
    });

    test('selectNextCategory moves to next category', () async {
      viewModel.selectNextCategory();
      await Future.delayed(Duration.zero); // wait for async

      verify(mockService.getCategoryContentFor(testCategories[1])).called(1);
      expect(viewModel.currentCategory.value, equals(testCategories[1]));
    });

    test('selectPreviousCategory moves to previous category', () async {
      viewModel.selectPreviousCategory();
      await Future.delayed(Duration.zero); // wait for async

      expect(viewModel.currentCategory.value, equals(testCategories.last));
      verify(mockService.getCategoryContentFor(testCategories.last)).called(1);
    });

    test('selectCategory updates current category and fetches content', () async {
      final newCategory = testCategories[1];
      viewModel.selectCategory(newCategory);

      expect(viewModel.currentCategory.value, equals(newCategory));
      verify(mockService.getCategoryContentFor(newCategory)).called(1);
    });

    test('selectCategory does nothing if same category selected', () async {
      final initialCategory = viewModel.currentCategory.value;
      reset(mockService);

      viewModel.selectCategory(initialCategory!);

      verifyNever(mockService.getCategoryContentFor(any));
    });
  });

  group('content navigation', () {
    setUp(() async {
      viewModel = KiteViewModel(mockService);
      await Future.delayed(Duration.zero);
    });

    test('selectContent updates current content', () {
      final selectedContent = testContent.first;
      viewModel.selectContent(selectedContent);

      expect(viewModel.currentCategoryContent.value.$1, equals(selectedContent));
      expect(viewModel.currentCategoryContent.value.$2, equals(testContent));
    });

    test('selectNextCluster moves to next content', () {
      viewModel.selectContent(testContent.first);
      viewModel.selectNextCluster();

      expect(viewModel.currentCategoryContent.value.$1, equals(testContent[1]));
    });

    test('selectPreviousCluster moves to previous content', () {
      viewModel.selectContent(testContent[1]);
      viewModel.selectPreviousCluster();

      expect(viewModel.currentCategoryContent.value.$1, equals(testContent[0]));
    });

    test('selectNextCluster wraps around to first content', () {
      viewModel.selectContent(testContent.last);
      viewModel.selectNextCluster();

      expect(viewModel.currentCategoryContent.value.$1, equals(testContent.first));
    });
  });

  group('categories list visibility', () {
    setUp(() {
      viewModel = KiteViewModel(mockService);
    });

    test('toggleCategoriesList toggles visibility', () {
      expect(viewModel.showingCategoriesList.value, isFalse);

      viewModel.toggleCategoriesList();
      expect(viewModel.showingCategoriesList.value, isTrue);

      viewModel.toggleCategoriesList();
      expect(viewModel.showingCategoriesList.value, isFalse);
    });

    test('selecting category hides categories list', () {
      viewModel.toggleCategoriesList();
      expect(viewModel.showingCategoriesList.value, isTrue);

      viewModel.selectCategory(testCategories[1]);
      expect(viewModel.showingCategoriesList.value, isFalse);
    });
  });
}
