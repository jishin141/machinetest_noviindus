import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../data/home_service.dart';
import '../data/models.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider(this._service);
  final HomeService _service;

  List<CategoryModel> categories = [];
  List<FeedModel> feeds = [];
  List<FeedModel> filteredFeeds = [];
  bool loading = false;
  String? error;
  String selectedCategory = 'Explore';

  // User information
  String? userName;
  String? userPhone;

  int? _playingId;
  VideoPlayerController? _controller;

  int? get playingId => _playingId;
  VideoPlayerController? get controller => _controller;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      // Load both categories and feeds from the same home API call
      final homeData = await _service.fetchHomeData();

      // Get categories from home API only (category_dict)
      final homeCategories = (homeData['category_dict'] as List?) ?? [];
      categories = homeCategories
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Get feeds from home API
      final list = (homeData['results'] as List?) ?? [];
      feeds = list
          .map((e) => FeedModel.fromJson(e as Map<String, dynamic>))
          .toList();
      filteredFeeds = feeds; // Initially show all feeds

      // Extract user information
      final userData = homeData['user'];
      if (userData is Map<String, dynamic>) {
        userName = userData['name'] as String?;
        userPhone = userData['phone'] as String?;
      }

      if (kDebugMode) {
        // ignore: avoid_print
        print('Home categories: ${categories.map((c) => c.title).toList()}');
        // ignore: avoid_print
        print(
          'Loaded ${categories.length} categories and ${feeds.length} feeds',
        );
        if (feeds.isNotEmpty) {
          // ignore: avoid_print
          print('First feed video URL: ${feeds.first.videoUrl}');
        }
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> play(FeedModel feed) async {
    if (_playingId == feed.id) return;
    await _disposeController();
    _playingId = feed.id;
    _controller = VideoPlayerController.networkUrl(Uri.parse(feed.videoUrl));
    await _controller!.initialize();
    _controller!.setLooping(false);
    await _controller!.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _controller?.pause();
    notifyListeners();
  }

  Future<void> _disposeController() async {
    await _controller?.dispose();
    _controller = null;
    _playingId = null;
  }

  void selectCategory(String category) {
    selectedCategory = category;
    if (category == 'All Categories') {
      filteredFeeds = feeds; // Show all feeds
    } else if (category == 'Explore' || category == 'Trending') {
      filteredFeeds = feeds; // Show all feeds for now
    } else {
      // Filter by specific category (assuming feeds have category info)
      // For now, show all feeds since we don't have category filtering in the API
      filteredFeeds = feeds;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}
