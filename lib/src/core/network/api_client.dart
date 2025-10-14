import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = 'https://frijo.noviindus.in/api/';
  final http.Client _client;

  Uri _u(String path, [Map<String, dynamic>? query]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: query);

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return _client.get(_u(path, query), headers: headers);
  }

  Future<http.Response> postForm(
    String path,
    Map<String, String> form, {
    String? token,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return _client.post(_u(path), headers: headers, body: form);
  }

  Future<http.StreamedResponse> postMultipart(
    String path, {
    required Map<String, String> fields,
    required Map<String, File> files,
    String? token,
  }) async {
    final request = http.MultipartRequest('POST', _u(path));
    request.fields.addAll(fields);
    for (final entry in files.entries) {
      request.files.add(
        await http.MultipartFile.fromPath(entry.key, entry.value.path),
      );
    }
    request.headers['Accept'] = 'application/json';
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    return request.send();
  }

  dynamic decode(http.Response r) => json.decode(utf8.decode(r.bodyBytes));
}
