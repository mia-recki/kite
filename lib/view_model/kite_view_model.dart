import 'package:flutter/foundation.dart' hide Category;

import '../data/kite_service.dart';
import '../data/models/category.dart';
import '../data/models/content.dart';

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
  ValueListenable<PopupType> get popupType => _popupType;

  final _currentCategory = ValueNotifier<Category?>(null);
  final _currentCategoryContent = ValueNotifier<(Content?, List<Content>?)>((null, null));
  final _popupType = ValueNotifier(PopupType.none);

  Future<void> _fetchContentFor(Category category) async {
    final newContent = (await _service.getCategoryContentFor(category)) ?? [];
    _currentCategoryContent.value = (null, newContent);
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

    _popupType.value = PopupType.none;

    _currentCategory.value = category;
    _fetchContentFor(category);
  }

  void toggleCategoriesList() {
    _popupType.value = _popupType.value.toggle(PopupType.categoriesList);
  }

  void toggleHelp() {
    _popupType.value = _popupType.value.toggle(PopupType.help);
  }
}

enum PopupType {
  none,
  categoriesList,
  help;

  PopupType toggle(PopupType type) => type == this ? none : type;
}
