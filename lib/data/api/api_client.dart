import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../utils/result.dart';

class ApiClient {
  ApiClient({@visibleForTesting http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _baseUrl = 'kite.kagi.com';
  final _categoriesEndpoint = Uri.https(_baseUrl, '/kite.json');
  Uri _fileEndpoint(String file) => Uri.https(_baseUrl, '/$file');

  Future<Result<Map<String, Object?>>> getCategories() async {
    final response = await _client.get(_categoriesEndpoint);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Success(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return const Failure('Failed to load categories');
  }

  Future<Result<Map<String, Object?>>> getCategoryContent(String file) async {
    final response = await _client.get(_fileEndpoint(file));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Success(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return Failure('Failed to load clusters from $file');
  }
}
