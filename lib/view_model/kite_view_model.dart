import 'package:flutter/foundation.dart' hide Category;

import '../data/kite_service.dart';
import '../data/models/category.dart';
import '../data/models/content.dart';
import '../data/models/history.dart';

class KiteViewModel {
  final KiteService _service;

  KiteViewModel(this._service) {
    _service.getCategories().then((categories) {
      if (categories case final List<Category> categories) {
        _currentCategory.value = categories.first;
        _fetchContentFor(categories.first);
      }
    });
  }

  ValueListenable<Category?> get currentCategory => _currentCategory;
  ValueListenable<(Content? currentCluster, List<Content>? clusters)> get currentCategoryContent =>
      _currentCategoryContent;
  ValueListenable<bool> get showingCategoriesList => _showingCategoriesList;

  final _currentCategory = ValueNotifier<Category?>(null);
  final _currentCategoryContent = ValueNotifier<(Content?, List<Content>?)>((null, null));
  final _showingCategoriesList = ValueNotifier(false);

  Future<void> _fetchContentFor(Category category) async {
    final newContent = (await _service.getCategoryContentFor(category)) ?? [];
    _currentCategoryContent.value = (null, newContent);
  }

  Future<List<Category>?> fetchCategories() async {
    return await _service.getCategories();
  }

  void selectNextCategory() => _selectCategory(1);
  void selectPreviousCategory() => _selectCategory(-1);

  Future<void> _selectCategory(int increment) async {
    final categories = await _service.getCategories();
    final currentCategory = _currentCategory.value;
    if (categories != null && currentCategory != null) {
      final index = categories.indexWhere((c) => c.name == currentCategory.name);
      if (index == -1) return;
      final nextCategoryIndex = (index + increment) % categories.length;
      final nextCategory = categories[nextCategoryIndex];
      _currentCategory.value = nextCategory;
      _fetchContentFor(nextCategory);
    }
  }

  void selectNextCluster() => _selectCluster(1);
  void selectPreviousCluster() => _selectCluster(-1);

  void _selectCluster(int increment) {
    if (_currentCategoryContent.value case (
      final Content? current,
      final List<Content> clusters,
    ) when clusters.isNotEmpty) {
      final currentIndex = current != null ? clusters.indexOf(current) : -1;
      final nextClusterIndex = (currentIndex + increment) % clusters.length;
      _currentCategoryContent.value = (clusters[nextClusterIndex], clusters);
    }
  }

  void selectContent(Content? content) {
    _currentCategoryContent.value = (content, _currentCategoryContent.value.$2);
  }

  void selectCategory(Category category) {
    if (_currentCategory.value == category) return;

    _showingCategoriesList.value = false;
    _currentCategory.value = category;
    _fetchContentFor(category);
  }

  void toggleCategoriesList() => _showingCategoriesList.value = !_showingCategoriesList.value;
}
