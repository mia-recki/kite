import 'package:flutter_test/flutter_test.dart';
import 'package:kite/data/exceptions.dart';
import 'package:kite/data/models/category.dart';
import 'package:kite/data/models/codable/category_codable.dart';
import 'package:kite/utils/result.dart';

import '../../../test_data/json_responses.dart';

void main() {
  group('CategoryCodable', () {
    group('with invalid json', () {
      const emptyJson = <String, Object?>{};
      const noCategoriesJson = {'a': 'b'};
      const invalidCategoriesJson = {'categories': 'invalid'};

      test('returns an Error', () {
        for (final json in [emptyJson, noCategoriesJson, invalidCategoriesJson]) {
          final result = CategoryCodable.decode(json);
          expect(result, isA<Failure<List<Category>>>());
          expect(result.error, isA<InvalidCategoryListException>());
        }
      });
    });

    group('with valid json', () {
      final result = CategoryCodable.decode(kiteJson);

      test('returns a Success<List<Category>> ', () => expect(result, isA<Success<List<Category>>>()));

      test('all categories are decoded correctly', () {
        final categories = (result as Success).value;

        expect(categories.length, 37);

        expect(categories.map((c) => (c.name, c.file)), [
          ('World', 'world.json'),
          ('USA', 'usa.json'),
          ('Business', 'business.json'),
          ("Technology", "tech.json"),
          ("Science", "science.json"),
          ("Sports", "sports.json"),
          ("Gaming", "gaming.json"),
          ("Bay Area", "bay.json"),
          ("Linux & OSS", "linux & oss.json"),
          ("Cryptocurrency", "cryptocurrency.json"),
          ("Europe", "europe.json"),
          ("UK", "uk.json"),
          ("Ukraine", "ukraine.json"),
          ("Brazil", "brazil.json"),
          ("Australia", "australia.json"),
          ("Estonia", "estonia.json"),
          ("Mexico", "mexico.json"),
          ("Germany", "germany.json"),
          ("Germany | Hesse", "germany | hesse.json"),
          ("Italy", "italy.json"),
          ("Canada", "canada.json"),
          ("Thailand", "thailand.json"),
          ("Serbia", "serbia.json"),
          ("USA | Vermont", "usa | vermont.json"),
          ("Japan", "japan.json"),
          ("Israel", "israel.json"),
          ("New Zealand", "new zealand.json"),
          ("Portugal", "portugal.json"),
          ("France", "france.json"),
          ("Poland", "poland.json"),
          ("Slovenia", "slovenia.json"),
          ("Spain", "spain.json"),
          ("Ireland", "ireland.json"),
          ("Belgium", "belgium.json"),
          ("The Netherlands", "the netherlands.json"),
          ("Romania", "romania.json"),
          ("OnThisDay", "onthisday.json"),
        ]);
      });
    });

    group('with invalid categories inside valid json', () {
      const invalidCategoriesKiteJson = {
        "timestamp": 1741700412,
        "categories": [
          {"name": "World", "file": "world.json"},
          {"name": "USA", "file": "usa.json"},
          {"name": "Business", "file": "business.json"},
          {"name": "Technology", "file": "tech.json"},
          {'name': 'invalid'},
          {'file': 3},
          {},
          {"name": "Science", "file": "science.json"},
        ],
      };

      final result = CategoryCodable.decode(invalidCategoriesKiteJson);

      test('all categories are decoded correctly, invalid categories are not in the result', () {
        final parsedCategories = result.value;

        expect((invalidCategoriesKiteJson['categories'] as List).length, 8);
        expect(parsedCategories!.length, 5);
        expect(parsedCategories.where((c) => c.name == 'invalid').length, 0);
      });
    });
  });
}
