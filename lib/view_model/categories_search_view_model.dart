import 'package:flutter/foundation.dart' hide Category;
import 'package:fuzzywuzzy/fuzzywuzzy.dart' as wuzzy;

import '../data/kite_service.dart';
import '../data/models/category.dart';

typedef SearchResult = (int? focusedIndex, List<Category>? categories);

extension SearchResultExtension on SearchResult {
  Category? get focusedCategory {
    if ($1 != null && $2 != null) {
      return $2![$1!];
    }
    return null;
  }
}

class CategoriesSearchViewModel {
  final KiteService _service;
  final List<Category> Function(String)? _search;

  CategoriesSearchViewModel(this._service, [@visibleForTesting this._search]) {
    _service.getCategories().then((categories) {
      _categories = categories;
      _searchResults.value = (categories == null ? null : 0, categories);
    });
  }

  List<Category>? _categories;

  ValueListenable<SearchResult> get searchResults => _searchResults;
  final _searchResults = ValueNotifier<SearchResult>((null, null));

  void search(String query) {
    final searchResults =
        _search?.call(query) ??
        wuzzy
            .extractAllSorted<Category>(
              query: query,
              choices: _categories ?? [],
              cutoff: query.isEmpty ? 0 : 50,
              getter: (category) => category.name.toLowerCase(),
            )
            .map((result) => result.choice)
            .toList();

    _searchResults.value = (searchResults.isEmpty ? null : 0, searchResults);
  }

  void focusNextResult() => _focus(1);

  void focusPreviousResult() => _focus(-1);

  void _focus(int increment) {
    if (_searchResults.value case (final int currentIndex, final List<Category> categories)) {
      final index = (currentIndex + increment) % categories.length;
      if (index >= 0 && index < categories.length) {
        _searchResults.value = (index, _searchResults.value.$2);
      }
    }
  }
}
