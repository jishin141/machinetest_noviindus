import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/network/api_client.dart';
import 'models.dart';

class HomeService {
  HomeService({ApiClient? client}) : _client = client ?? ApiClient();
  final ApiClient _client;

  Future<Map<String, dynamic>> fetchHomeData() async {
    final r = await _client.get('home');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      final data = _client.decode(r) as Map<String, dynamic>;
      // Debug: print response structure
      if (kDebugMode) {
        // ignore: avoid_print
        print('Home API response: $data');
      }
      return data;
    }
    throw http.ClientException('Failed to load home data: ${r.statusCode}');
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final data = await fetchHomeData();
    final list = (data['category_dict'] as List?) ?? [];
    return list
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FeedModel>> fetchHomeFeeds() async {
    final data = await fetchHomeData();
    final list = (data['results'] as List?) ?? [];
    if (kDebugMode) {
      // ignore: avoid_print
      print('Feeds list length: ${list.length}');
      if (list.isNotEmpty) {
        // ignore: avoid_print
        print('First feed: ${list.first}');
        // Debug: print image URLs from home API
        for (int i = 0; i < list.length && i < 3; i++) {
          // ignore: avoid_print
          print('Home Feed ${i + 1} image: ${list[i]['image']}');
        }
      }
    }
    return list
        .map((e) => FeedModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CategoryModel>> fetchAdditionalCategories() async {
    final r = await _client.get('category_list');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      final data = _client.decode(r) as Map<String, dynamic>;
      final list = (data['categories'] as List?) ?? [];
      return list
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return []; // Return empty list if API fails
  }
}
