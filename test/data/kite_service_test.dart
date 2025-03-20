import 'package:flutter_test/flutter_test.dart';
import 'package:kite/data/api/api_client.dart';
import 'package:kite/data/kite_service.dart';
import 'package:kite/data/models/category.dart';
import 'package:kite/data/models/content.dart';
import 'package:kite/utils/date_utils.dart';
import 'package:kite/utils/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data/json_responses.dart';
@GenerateNiceMocks([MockSpec<ApiClient>()])
import 'kite_service_test.mocks.dart';

void main() {
  group('KiteService', () {
    late MockApiClient apiClient;
    late KiteService sut;

    setUp(() {
      provideDummy(Result<Map<String, Object?>>.success(kiteJson));
      apiClient = MockApiClient();
      sut = KiteService(apiClient);
    });

    group('when getCategories is called', () {
      late List<Category>? result;
      group('and no categories are cached', () {
        group('and the api call returns a valid response', () {
          setUp(() async {
            when(apiClient.getCategories()).thenAnswer((_) async => Success(kiteJson));
            result = await sut.getCategories();
          });

          test('then api client is queried', () => verify(apiClient.getCategories()).called(1));

          test('then a list of categories is returned', () => expect(result, isA<List<Category>>()));
        });

        group('and the api call does not return a valid response', () {
          setUp(() async {
            when(apiClient.getCategories()).thenAnswer((_) async => const Failure(''));
            result = await sut.getCategories();
          });

          test('then api client is queried', () => verify(apiClient.getCategories()).called(1));

          test('then null is returned', () => expect(result, isNull));
        });
      });

      group('and categories are already cached', () {
        setUp(() async {
          when(apiClient.getCategories()).thenAnswer((_) async => Success(kiteJson));
          await sut.getCategories(); // fetch the categories for the first time
          reset(apiClient);
          result = await sut.getCategories(); // second call to getCategories
        });

        test('then no calls to api client are made', () => verifyNever(apiClient.getCategories()));

        test('then a list of categories is returned', () => expect(result, isA<List<Category>>()));
      });
    });

    group('when getClusters is called', () {
      const category = Category(name: 'World', file: 'world.json');
      final worldJsonResponseTime = DateTime.fromMillisecondsSinceEpoch((worldJson()['timestamp'] as int) * 1000);

      late List<Content>? result;
      group('and no clusters are cached', () {
        group('and the api call gets a valid response', () {
          setUp(() async {
            when(apiClient.getCategoryContent(category.file)).thenAnswer((_) async => Success(worldJson()));
            result = await sut.getCategoryContentFor(category);
          });

          test(
            'then categories are fetched from the api',
            () => verify(apiClient.getCategoryContent(category.file)).called(1),
          );

          test('then a list of clusters is returned', () => expect(result, isA<List<Content>>()));
        });

        group('and the api call does not return a valid response', () {
          setUp(() async {
            when(apiClient.getCategoryContent(category.file)).thenAnswer((_) async => const Failure(''));
            result = await sut.getCategoryContentFor(category);
          });

          test('then clusters are fetched from the api', () => verify(apiClient.getCategoryContent(category.file)).called(1));

          test('then null is returned', () => expect(result, isNull));
        });
      });

      group('and clusters are already cached', () {
        group('and new data is not yet available', () {
          setUp(() async {
            sut.currentTime = () => worldJsonResponseTime.refreshTime.subtract(const Duration(hours: 7));
            when(apiClient.getCategoryContent(category.file)).thenAnswer((_) async => Success(worldJson()));
            await sut.getCategoryContentFor(category); // cache clusters
            reset(apiClient);

            result = await sut.getCategoryContentFor(category); // second call to getClustersFor
          });

          test('then no api calls are made', () => verifyNever(apiClient.getCategoryContent(category.file)));

          test('then a list of clusters is returned', () => expect(result, isA<List<Content>>()));
        });

        group('and new data should be available', () {
          setUp(() async {
            sut.currentTime = () => worldJsonResponseTime.refreshTime.add(const Duration(hours: 7));
            when(apiClient.getCategoryContent(category.file)).thenAnswer((_) async => Success(worldJson()));
            await sut.getCategoryContentFor(category); // cache clusters
            reset(apiClient); // reset client so only
          });

          group('and the api call gets a valid response', () {
            setUp(() async {
              when(apiClient.getCategoryContent(category.file)).thenAnswer((_) async => Success(worldJson()));
              result = await sut.getCategoryContentFor(category); // second call to getClustersFor
            });

            test(
              'then categories are fetched from the api',
              () => verify(apiClient.getCategoryContent(category.file)).called(1),
            );

            test('then a list of clusters is returned', () => expect(result, isA<List<Content>>()));
          });

          group('and the api call does not return a valid response', () {
            setUp(() async {
              when(apiClient.getCategoryContent(category.file)).thenAnswer((_) async => const Failure(''));
              result = await sut.getCategoryContentFor(category); // second call to getClustersFor
            });

            test(
              'then clusters are fetched from the api',
              () => verify(apiClient.getCategoryContent(category.file)).called(1),
            );

            test('then null is returned', () => expect(result, isNull));
          });
        });
      });
    });
  });
}
