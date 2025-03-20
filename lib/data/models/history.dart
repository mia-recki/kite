import 'package:collection/collection.dart';

import 'content.dart';

enum HistoryType { event, people }

class History extends Content {
  final List<HistoryItem> items;

  const History(this.items);

  List<HistoryItem> get events =>
      items.where((i) => i.type == HistoryType.event).sortedBy((e) => e.sortYear).reversed.toList();
  List<HistoryItem> get people =>
      items.where((i) => i.type == HistoryType.people).sortedBy((e) => e.sortYear).reversed.toList();
}

class HistoryItem {
  final HistoryType type;
  final String year;
  final num sortYear;
  final String content;

  const HistoryItem({required this.type, required this.year, required this.sortYear, required this.content});
}
