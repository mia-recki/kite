import 'package:flutter/foundation.dart' hide Category;

import '../utils/date_utils.dart';
import '../utils/result.dart';
import 'api/api_client.dart';
import 'models/category.dart';
import 'models/codable/category_codable.dart';
import 'models/codable/cluster_codable.dart';
import 'models/codable/history_codable.dart';
import 'models/content.dart';
import 'models/history.dart';

/// Fetches data from the Kite API and caches it in memory
// NOTE: at a later stage, there could be a [_localClient] that would store data locally, to enable offline functionality accross app restarts
class KiteService {
  final ApiClient _remoteClient;

  KiteService(this._remoteClient);

  List<Category>? _categories;
  final _clusterData = <Category, (DateTime, List<Content>)?>{};

  Future<List<Category>?> getCategories() async {
    // TODO: should categories be fetched if already present?
    if (_categories case final List<Category> categories when categories.isNotEmpty) {
      return categories;
    }

    // fetch data from the api endpoint
    final response = await _remoteClient.getCategories();
    return switch (response) {
      Failure() => null,
      Success(value: final json) => switch (CategoryCodable.decode(json)) {
        Success(value: final categories) => () {
          _categories = categories;
          return categories;
        }(),
        Failure() => null,
      },
    };
  }

  Future<List<Content>?> getCategoryContentFor(Category category) async {
    if (_clusterData[category] case (final DateTime timestamp, final List<Content> content)) {
      if (!_isNewDataAvailable(timestamp)) {
        return content;
      }
    }

    final response = await _remoteClient.getCategoryContent(category.file);
    return switch (response) {
      Failure() => null,
      Success(value: final json) => switch (category.file) {
        'onthisday.json' => <History>[HistoryCodable.decode(json)],
        _ => switch (ClusterCodable.decode(json)) {
          Success(value: final clusters) => () {
            _clusterData[category] = (_getTime(json), clusters);
            return clusters;
          }(),
          Failure() => null,
        },
      },
    };
  }

  DateTime _getTime(Map<String, Object?> json) {
    final milliseconds = (json['timestamp'] as int) * 1000;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
  }

  /// from kite.kagi.com intro screen: new data is availabe once a day at noon UTC
  bool _isNewDataAvailable(DateTime availableDataTimestamp) {
    final now = currentTime();
    final refreshTime = availableDataTimestamp.refreshTime;
    return availableDataTimestamp.isBefore(refreshTime) && now.isAfter(refreshTime);
  }

  @visibleForTesting
  ValueGetter<DateTime> currentTime = () => DateTime.now();
}
