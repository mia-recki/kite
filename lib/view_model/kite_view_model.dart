import 'package:flutter/foundation.dart' hide Category;

import '../data/kite_service.dart';
import '../data/models/category.dart';
import '../data/models/cluster.dart';

class KiteViewModel {
  final KiteService _service;

  KiteViewModel(this._service) {
    _service.getCategories().then((categories) {
      if (categories case final List<Category> categories) {
        _currentCategory.value = categories.first;
        _fetchClustersFor(categories.first);
      }
    });
  }

  ValueListenable<Category?> get currentCategory => _currentCategory;
  ValueListenable<(Cluster? currentCluster, List<Cluster>? clusters)> get currentCategoryClusters =>
      _currentCategoryClusters;
  ValueListenable<bool> get showingCategoriesList => _showingCategoriesList;

  final _currentCategory = ValueNotifier<Category?>(null);
  final _currentCategoryClusters = ValueNotifier<(Cluster?, List<Cluster>?)>((null, null));
  final _showingCategoriesList = ValueNotifier(false);

  Future<void> _fetchClustersFor(Category category) async {
    final newClusters = (await _service.getClustersFor(category)) ?? [];
    _currentCategoryClusters.value = (null, newClusters);
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
      _fetchClustersFor(nextCategory);
    }
  }

  void selectNextCluster() => _selectCluster(1);
  void selectPreviousCluster() => _selectCluster(-1);

  void _selectCluster(int increment) {
    if (_currentCategoryClusters.value case (
      final Cluster? current,
      final List<Cluster> clusters,
    ) when clusters.isNotEmpty) {
      final currentIndex = current != null ? clusters.indexOf(current) : -1;
      final nextClusterIndex = (currentIndex + increment) % clusters.length;
      _currentCategoryClusters.value = (clusters[nextClusterIndex], clusters);
    }
  }

  void selectCluster(Cluster cluster) {
    if (_currentCategoryClusters.value case (_, final List<Cluster> clusters)) {
      _currentCategoryClusters.value = (cluster, clusters);
    }
  }

  void selectCategory(Category category) {
    if (_currentCategory.value == category) return;

    _showingCategoriesList.value = false;
    _currentCategory.value = category;
    _fetchClustersFor(category);
  }

  void toggleCategoriesList() => _showingCategoriesList.value = !_showingCategoriesList.value;
}
