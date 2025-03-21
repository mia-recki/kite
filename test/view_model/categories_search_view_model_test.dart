import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/data/models/category.dart';
import 'package:kite/view_model/categories_search_view_model.dart';
import 'package:mockito/mockito.dart';

import 'kite_view_model_test.mocks.dart';

class MockSearchResultListener with Mock {
  call();
}

void main() {
  group('CategoriesSearchViewModel', () {
    late CategoriesSearchViewModel sut;
    late MockKiteService service;
    late MockSearchResultListener listener;

    setUp(() {
      service = MockKiteService();
      listener = MockSearchResultListener();
    });

    group('when service is unable to deliver categories', () {
      setUp(() {
        when(service.getCategories()).thenAnswer((_) async => null);
        sut = CategoriesSearchViewModel(service)..searchResults.addListener(listener.call);
      });

      test('then view model queries service for categories', () => verify(service.getCategories()).called(1));

      test('then search results do not change', () async {
        expect(sut.searchResults.value.$1, isNull);
        expect(sut.searchResults.value.$2.isEmpty, true);
        verifyNever(listener.call());
      });

      group('and when performing a search', () {
        setUp(() => sut.search('a'));

        test('there are no updates', () {
          expect(sut.searchResults.value.$1, isNull);
          expect(sut.searchResults.value.$2.isEmpty, true);
          verifyNever(listener.call());
        });
      });

      group('and when focusing next/previous search result', () {
        setUp(() {
          sut.focusNextResult();
          sut.focusPreviousResult();
          sut.focusNextResult();
          sut.focusNextResult();
        });

        test('there are no updates', () => verifyNever(listener.call()));
      });
    });

    group('when service returns categories', () {
      final categories = ['a', 'b', 'c', 'd', 'e'].map((c) => Category(name: c, file: '$c.json')).toList();
      final searchResult = [categories.first, categories[3], categories.last];

      setUp(() {
        when(service.getCategories()).thenAnswer((_) async => categories);
        sut = CategoriesSearchViewModel(service, (a) => searchResult)..searchResults.addListener(listener.call);
      });

      test('then view model queries service for categories', () => verify(service.getCategories()).called(1));

      test('then search results are updated', () async {
        verify(listener.call()).called(1);
        expect(sut.searchResults.value.$1, equals(0));
        expect(sut.searchResults.value.$2, categories);
      });

      group('and when performing a search', () {
        setUp(() {
          reset(listener);
          sut.search('a');
        });

        test('then results are updated with categories matching that query', () {
          verify(listener.call()).called(1);
          expect(sut.searchResults.value.$1, 0);
          expect(const DeepCollectionEquality().equals(sut.searchResults.value.$2, searchResult), isTrue);
        });
      });

      group('and when focusing next/previous search result', () {
        test('results are updated accordingly', () {
          reset(listener);
          sut.focusNextResult();
          verify(listener.call()).called(1);
          expect(sut.searchResults.value.$1, 1);

          reset(listener);
          sut.focusNextResult();
          verify(listener.call()).called(1);
          expect(sut.searchResults.value.$1, 2);

          reset(listener);
          // loop back to last result
          sut.focusPreviousResult();
          sut.focusPreviousResult();
          sut.focusPreviousResult();
          verify(listener.call()).called(3);
          expect(sut.searchResults.value.$1, 4);
        });
      });
    });
  });
}
