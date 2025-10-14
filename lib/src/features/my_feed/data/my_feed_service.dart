// import '../../../core/network/api_client.dart';
// import '../../home/data/models.dart';

// class MyFeedService {
//   MyFeedService({ApiClient? client}) : _client = client ?? ApiClient();
//   final ApiClient _client;

//   Future<List<FeedModel>> fetch({
//     required String token,
//     required int page,
//   }) async {
//     final r = await _client.get(
//       'my_feed',
//       query: {'page': '$page'},
//       token: token,
//     );
//     if (r.statusCode >= 200 && r.statusCode < 300) {
//       final data = _client.decode(r) as Map<String, dynamic>;
//       final list = (data['data'] as List?) ?? [];
//       return list
//           .map((e) => FeedModel.fromJson(e as Map<String, dynamic>))
//           .toList();
//     }
//     throw Exception('Failed: ${r.statusCode}');
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../home/data/models.dart';

class MyFeedService {
  final _baseUrl = 'https://frijo.noviindus.in/api';

  Future<List<FeedModel>> fetchMyFeeds(String token, {int page = 1}) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/my_feed?page=$page'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      // Debug: print my_feed API response
      print('My Feed API response: $data');
      final List results =
          data['results'] ??
          data['data'] ??
          []; // Try both 'results' and 'data'
      print('My Feed results length: ${results.length}');
      if (results.isNotEmpty) {
        print('First my feed: ${results.first}');
        // Debug: print all image URLs to see if they're different
        for (int i = 0; i < results.length && i < 3; i++) {
          print('Feed ${i + 1} image: ${results[i]['image']}');
        }
      }
      return results.map((e) => FeedModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load feeds: ${res.statusCode}');
    }
  }
}
