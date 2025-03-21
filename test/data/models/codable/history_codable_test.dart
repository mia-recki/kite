import 'package:flutter_test/flutter_test.dart';
import 'package:kite/data/models/codable/history_codable.dart';
import 'package:kite/data/models/history.dart';

void main() {
  group('HistoryCodable', () {
    test('decode should correctly parse valid history JSON', () {
      final json = {
        'events': [
          {'year': '1969', 'content': 'Moon landing', 'type': 'event', 'sort_year': 1969},
          {'year': '1452', 'content': 'Leonardo da Vinci born', 'type': 'people', 'sort_year': 1452},
        ],
      };

      final result = HistoryCodable.decode(json);

      expect(result, isA<History>());
      expect(result.items.length, 2);

      expect(result.items[0].year, '1969');
      expect(result.items[0].content, 'Moon landing');
      expect(result.items[0].type, HistoryType.event);
      expect(result.items[0].sortYear, 1969);

      expect(result.items[1].year, '1452');
      expect(result.items[1].content, 'Leonardo da Vinci born');
      expect(result.items[1].type, HistoryType.people);
      expect(result.items[1].sortYear, 1452);
    });

    test('decode should throw exception for invalid history type', () {
      final json = {
        'events': [
          {'year': '2000', 'content': 'Test content', 'type': 'invalid_type', 'sort_year': 2000},
        ],
      };

      expect(
        () => HistoryCodable.decode(json),
        throwsA(
          isA<Exception>().having((e) => e.toString(), 'message', 'Exception: Invalid history type invalid_type'),
        ),
      );
    });

    test('decode should throw exception for invalid JSON structure', () {
      final json = {'wrong_key': []};

      expect(
        () => HistoryCodable.decode(json),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Invalid history json'))),
      );
    });

    test('decode skips invalid events in the JSON', () {
      final json = {
        'events': [
          {
            'year': '2000',
            'content': 'Test content',
            // Missing 'type' field
            'sort_year': 2000,
          },
        ],
      };

      expect(HistoryCodable.decode(json), isA<History>());
      expect(HistoryCodable.decode(json).items, isEmpty);
    });

    test('decode should throw exception for malformed event object', () {
      final json = {
        'people': [
          {'year': '2000', 'content': 'Test content', 'sort_year': 2000},
        ],
      };

      expect(() => HistoryCodable.decode(json), throwsA(isA<Exception>()));
    });
  });
}
