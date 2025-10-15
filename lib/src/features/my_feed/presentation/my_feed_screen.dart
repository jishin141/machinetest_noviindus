// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';

// // // import '../../../core/storage/token_storage.dart';
// // // import '../../home/data/models.dart';
// // // import '../data/my_feed_service.dart';
// // // import '../state/my_feed_provider.dart';

// // // class MyFeedScreen extends StatelessWidget {
// // //   const MyFeedScreen({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return ChangeNotifierProvider(
// // //       create: (_) => MyFeedProvider(MyFeedService(), TokenStorage())..refresh(),
// // //       child: Consumer<MyFeedProvider>(
// // //         builder: (context, p, _) => Scaffold(
// // //           appBar: AppBar(title: const Text('My Feed')),
// // //           body: NotificationListener<ScrollNotification>(
// // //             onNotification: (n) {
// // //               if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
// // //                 p.loadMore();
// // //               }
// // //               return false;
// // //             },
// // //             child: ListView.separated(
// // //               padding: const EdgeInsets.all(12),
// // //               itemBuilder: (_, i) {
// // //                 if (i == p.feeds.length) {
// // //                   return Padding(
// // //                     padding: const EdgeInsets.symmetric(vertical: 24),
// // //                     child: Center(
// // //                       child: p.hasMore
// // //                           ? const CircularProgressIndicator()
// // //                           : const Text('No more feeds'),
// // //                     ),
// // //                   );
// // //                 }
// // //                 final f = p.feeds[i];
// // //                 return _MyFeedTile(feed: f);
// // //               },
// // //               separatorBuilder: (_, __) => const SizedBox(height: 16),
// // //               itemCount: p.feeds.length + 1,
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _MyFeedTile extends StatelessWidget {
// // //   const _MyFeedTile({required this.feed});
// // //   final FeedModel feed;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         AspectRatio(
// // //           aspectRatio: 16 / 9,
// // //           child: feed.thumbnailUrl != null
// // //               ? Image.network(feed.thumbnailUrl!, fit: BoxFit.cover)
// // //               : Container(color: Colors.black12),
// // //         ),
// // //         const SizedBox(height: 8),
// // //         Text(feed.description, maxLines: 3, overflow: TextOverflow.ellipsis),
// // //       ],
// // //     );
// // //   }
// // // }
// // import '../../../core/network/api_client.dart';
// // import '../../home/data/models.dart';

// // class MyFeedScreen {
// //   MyFeedScreen({ApiClient? client}) : _client = client ?? ApiClient();
// //   final ApiClient _client;

// //   Future<List<FeedModel>> fetch({
// //     required String token,
// //     required int page,
// //   }) async {
// //     final r = await _client.get(
// //       'my_feed',
// //       query: {'page': '$page'},
// //       token: token,
// //     );

// //     if (r.statusCode >= 200 && r.statusCode < 300) {
// //       final data = _client.decode(r);
// //       // ✅ Fixed to handle the API structure you provided
// //       if (data is Map<String, dynamic>) {
// //         final list = (data['results'] as List?) ?? [];
// //         return list
// //             .map((e) => FeedModel.fromJson(e as Map<String, dynamic>))
// //             .toList();
// //       }
// //     }
// //     throw Exception('Failed: ${r.statusCode}');
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../core/storage/token_storage.dart';
// import '../../home/data/models.dart';
// import '../data/my_feed_service.dart';
// import '../state/my_feed_provider.dart';

// class MyFeedScreen extends StatelessWidget {
//   const MyFeedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => MyFeedProvider(MyFeedService(), TokenStorage())..refresh(),
//       child: Consumer<MyFeedProvider>(
//         builder: (context, p, _) => Scaffold(
//           appBar: AppBar(title: const Text('My Feed')),
//           body: NotificationListener<ScrollNotification>(
//             onNotification: (n) {
//               if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
//                 p.loadMore();
//               }
//               return false;
//             },
//             child: ListView.separated(
//               padding: const EdgeInsets.all(12),
//               itemBuilder: (_, i) {
//                 if (i == p.feeds.length) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 24),
//                     child: Center(
//                       child: p.hasMore
//                           ? const CircularProgressIndicator()
//                           : const Text('No more feeds'),
//                     ),
//                   );
//                 }
//                 final f = p.feeds[i];
//                 return _MyFeedTile(feed: f);
//               },
//               separatorBuilder: (_, __) => const SizedBox(height: 16),
//               itemCount: p.feeds.length + 1,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _MyFeedTile extends StatelessWidget {
//   const _MyFeedTile({required this.feed});
//   final FeedModel feed;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AspectRatio(
//           aspectRatio: 16 / 9,
//           child: feed.thumbnailUrl != null
//               ? Image.network(feed.thumbnailUrl!, fit: BoxFit.cover)
//               : Container(color: Colors.black12),
//         ),
//         const SizedBox(height: 8),
//         Text(feed.description, maxLines: 3, overflow: TextOverflow.ellipsis),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';

import '../../../app/router.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/utils/responsive.dart';
import '../../home/data/models.dart';
import '../data/my_feed_service.dart';
import '../state/my_feed_provider.dart';

class MyFeedScreen extends StatefulWidget {
  const MyFeedScreen({super.key});

  @override
  State<MyFeedScreen> createState() => _MyFeedScreenState();
}

class _MyFeedScreenState extends State<MyFeedScreen> {
  late MyFeedProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = MyFeedProvider(MyFeedService(), TokenStorage())..refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<MyFeedProvider>(
        builder: (context, p, _) {
          // 🩵 Debug logging (just temporary)
          debugPrint('Feeds count: ${p.feeds.length}');
          debugPrint('Has more: ${p.hasMore}');
          debugPrint('Error: ${p.error}');
          debugPrint('Loading: ${p.loading}');

          return Scaffold(
            appBar: AppBar(title: const Text('My Feed')),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRouter.routeAddFeed,
                );
                // If upload was successful, refresh the feeds
                if (result == true) {
                  p.refresh();
                }
              },
              child: const Icon(Icons.add),
            ),
            body: Builder(
              builder: (_) {
                if (p.loading && p.feeds.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (p.error != null) {
                  return Center(child: Text('Error: ${p.error}'));
                }

                if (p.feeds.isEmpty) {
                  return const Center(child: Text('No feeds found'));
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                      p.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: Responsive.getAllPadding(context),
                    itemCount: p.feeds.length + 1,
                    separatorBuilder: (_, __) => SizedBox(
                      height: Responsive.getSpacing(
                        context,
                        mobile: 12,
                        tablet: 16,
                        desktop: 20,
                      ),
                    ),
                    itemBuilder: (_, i) {
                      if (i == p.feeds.length) {
                        return Padding(
                          padding: Responsive.getVerticalPadding(
                            context,
                            mobile: 20,
                            tablet: 24,
                            desktop: 28,
                          ),
                          child: Center(
                            child: p.hasMore
                                ? const CircularProgressIndicator()
                                : Text(
                                    'No more feeds',
                                    style: TextStyle(
                                      fontSize: Responsive.getBodyFontSize(
                                        context,
                                      ),
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        );
                      }
                      final f = p.feeds[i];
                      return _MyFeedTile(feed: f);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MyFeedTile extends StatelessWidget {
  const _MyFeedTile({required this.feed});
  final FeedModel feed;

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyFeedProvider>(
      builder: (context, provider, _) {
        final isPlaying =
            provider.playingId == feed.id && provider.controller != null;

        Widget media;
        if (isPlaying) {
          media = AspectRatio(
            aspectRatio: provider.controller!.value.aspectRatio,
            child: Chewie(
              controller: ChewieController(
                videoPlayerController: provider.controller!,
                autoPlay: true,
                looping: false,
                allowFullScreen: true,
                allowMuting: true,
                allowPlaybackSpeedChanging: false,
              ),
            ),
          );
        } else {
          media = GestureDetector(
            onTap: () => provider.play(feed),
            child: AspectRatio(
              aspectRatio: Responsive.getAspectRatio(context),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (feed.thumbnailUrl != null &&
                      feed.thumbnailUrl!.isNotEmpty)
                    Image.network(
                      feed.thumbnailUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.black12,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Image load error for feed ${feed.id}: $error');
                        return Container(
                          color: Colors.black12,
                          child: const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: Colors.black12,
                      child: const Center(
                        child: Icon(Icons.image_not_supported),
                      ),
                    ),
                  const Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: Responsive.getHorizontalPadding(context).copyWith(
            top: Responsive.getSpacing(context),
            bottom: Responsive.getSpacing(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: Responsive.getAvatarRadius(context) * 2,
                    height: Responsive.getAvatarRadius(context) * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/profile_image.jpg'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.getSpacing(context)),
                  Expanded(
                    child: Text(
                      feed.user.name.isNotEmpty ? feed.user.name : 'You',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.getBodyFontSize(context),
                      ),
                    ),
                  ),
                  if (isPlaying)
                    IconButton(
                      onPressed: () => provider.pause(),
                      icon: Icon(
                        Icons.pause_circle_outline,
                        size: Responsive.getIconSize(context),
                      ),
                    ),
                ],
              ),
              SizedBox(height: Responsive.getSpacing(context)),
              media,
              SizedBox(height: Responsive.getSpacing(context)),
              Text(
                feed.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.getBodyFontSize(context),
                ),
              ),
              SizedBox(
                height: Responsive.getSpacing(
                  context,
                  mobile: 4,
                  tablet: 6,
                  desktop: 8,
                ),
              ),
              Text(
                // 'ID: ${feed.id} • '
                _formatDate(feed.createdAt),
                style: TextStyle(
                  fontSize: Responsive.getSmallFontSize(context),
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
