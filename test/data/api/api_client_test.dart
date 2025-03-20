import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:kite/data/api/api_client.dart';
import 'package:kite/utils/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Client>()])
import 'api_client_test.mocks.dart';

void main() {
  group('ApiClient', () {
    late MockClient client;
    late ApiClient sut;
    setUp(() {
      client = MockClient();
      sut = ApiClient(client: client);
    });

    group('when getCategories is called', () {
      group('and the response is OK', () {
        late Result<Map<String, Object?>> result;
        setUp(() async {
          when(client.get(any)).thenAnswer((_) async => Response('{"foo": "bar"}', 200));

          result = await sut.getCategories();
        });

        test(
          'then data is fetched from the correct endpoint',
          () => verify(client.get(Uri.https('kite.kagi.com', '/kite.json'))).called(1),
        );

        test('then Success is returned', () => expect(result, isA<Success>()));
      });

      group('and the response is not OK', () {
        late Result<Map<String, Object?>> result;
        setUp(() async {
          when(client.get(any)).thenAnswer((_) async => Response('error', 500));

          result = await sut.getCategories();
        });

        test(
          'then data is fetched from the correct endpoint',
          () => verify(client.get(Uri.https('kite.kagi.com', '/kite.json'))).called(1),
        );

        test('then Failure is returned', () => expect(result, isA<Failure>()));
      });
    });

    group('when getClusters is called for a file', () {
      group('and the response is OK', () {
        late Result<Map<String, Object?>> result;
        setUp(() async {
          when(client.get(any)).thenAnswer((_) async => Response('{"foo": "bar"}', 200));

          result = await sut.getCategoryContent('file.json');
        });

        test(
          'then data is fetched from the correct endpoint',
          () => verify(client.get(Uri.https('kite.kagi.com', '/file.json'))).called(1),
        );

        test('then Success is returned', () => expect(result, isA<Success>()));
      });

      group('and the response is not OK', () {
        late Result<Map<String, Object?>> result;
        setUp(() async {
          when(client.get(any)).thenAnswer((_) async => Response('error', 500));

          result = await sut.getCategoryContent('file.json');
        });

        test(
          'then data is fetched from the correct endpoint',
          () => verify(client.get(Uri.https('kite.kagi.com', '/file.json'))).called(1),
        );

        test('then Failure is returned', () => expect(result, isA<Failure>()));
      });
    });
  });
}
