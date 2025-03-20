import 'dart:convert';

import 'package:flutter/services.dart';

import '../../utils/result.dart';
import 'api_client.dart';

class DummyClient implements ApiClient {
  @override
  Future<Result<Map<String, Object?>>> getCategories() async {
    try {
      return Success(jsonDecode(await rootBundle.loadString('assets/test/kite.json')));
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<Map<String, Object?>>> getCategoryContent(String file) async {
    try {
      return Success(jsonDecode(await rootBundle.loadString('assets/test/$file')));
    } catch (e) {
      return Failure(e);
    }
  }
}
