import 'package:flutter_test/flutter_test.dart';
import 'package:kite/data/exceptions.dart';
import 'package:kite/data/models/codable/cluster_codable.dart';
import 'package:kite/data/models/content.dart';
import 'package:kite/utils/result.dart';

import '../../../test_data/json_responses.dart';

void main() {
  group('ClusterCodable', () {
    group('with invalid json', () {
      test('returns an Error', () {
        for (final j in [
          <String, Object?>{}, // empty
          {'invalid': 'json'}, // no clusters
          {'clusters': 'invalid'}, // invalid clusters format
        ]) {
          final result = ClusterCodable.decode(j);
          expect(result, isA<Failure<List<Content>>>());
          expect(result.error, InvalidClusterListException(invalidJson: j));
        }
      });
    });

    group('with valid json', () {
      late Result<List<Content>> result;

      setUp(() {
        result = ClusterCodable.decode(worldJson());
      });

      test('returns a Success<List<Cluster>>', () => expect(result, isA<Success<List<Content>>>()));
      test('parses all clusters', () => expect(result.value?.length, 12));
    });

    // TEST: more cluster tests
  });
}
