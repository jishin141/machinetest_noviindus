import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../../core/storage/token_storage.dart';
import '../../home/data/models.dart';

class MyFeedProvider extends ChangeNotifier {
  MyFeedProvider(this._service, this._storage);
  final _service;
  final TokenStorage _storage;

  final List<FeedModel> feeds = [];
  bool loading = false;
  bool hasMore = true;
  int _page = 1;
  String? error;

  int? _playingId;
  VideoPlayerController? _controller;

  int? get playingId => _playingId;
  VideoPlayerController? get controller => _controller;

  Future<void> refresh() async {
    feeds.clear();
    hasMore = true;
    _page = 1;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (!hasMore || loading) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final token = await _storage.readToken();
      if (token == null || token.isEmpty) {
        error = 'Not authenticated';
        return;
      }
      // final list = await _service.fetch(token: token, page: _page);
      final list = await _service.fetchMyFeeds(token, page: _page);

      if (kDebugMode) {
        // ignore: avoid_print
        print('My Feed Provider: Loaded ${list.length} feeds');
        if (list.isNotEmpty) {
          // ignore: avoid_print
          print('First my feed: ${list.first.description}');
        }
      }

      feeds.addAll(list);
      hasMore = list.isNotEmpty;
      if (hasMore) _page += 1;
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

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}
