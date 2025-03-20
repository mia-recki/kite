import '../history.dart';

class HistoryCodable {
  static History decode(Map<String, Object?> json) {
    if (json case {'events': final List<dynamic> events}) {
      final items = <HistoryItem>[];
      for (final event in events) {
        if (event case {
          'year': final String year,
          'content': final String content,
          'type': final String type,
          'sort_year': final num sortYear,
        }) {
          items.add(
            HistoryItem(
              type: switch (type) {
                'people' => HistoryType.people,
                'event' => HistoryType.event,
                _ => throw Exception('Invalid history type $type'),
              },
              content: content,
              year: year.toString(),
              sortYear: sortYear,
            ),
          );
        }
      }
      return History(items);
    }
    throw Exception('Invalid history json $json');
  }
}
