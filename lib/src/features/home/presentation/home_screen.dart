import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';

import '../../../app/router.dart';
import '../../../core/utils/responsive.dart';
import '../../home/data/models.dart';
import '../../home/state/home_provider.dart';
import '../../home/data/home_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(HomeService())..load(),
      child: Builder(
        builder: (context) {
          final provider = context.watch<HomeProvider>();
          return Scaffold(
            appBar: AppBar(
              title: _buildGreeting(context, provider),
              actions: [
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRouter.routeMyFeed,
                    );
                    // If returning from My Feed, refresh home screen
                    if (result == true) {
                      provider.load();
                    }
                  },
                  icon: const CircleAvatar(
                    radius: 34,
                    child: Icon(Icons.person, size: 24),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRouter.routeAddFeed,
                );
                // If upload was successful, refresh the home screen
                if (result == true) {
                  provider.load();
                }
              },
              child: const Icon(Icons.add),
            ),
            body: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text(provider.error!))
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: Responsive.getChipHeight(context),
                          child: ListView.separated(
                            padding: Responsive.getHorizontalPadding(context),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, i) {
                              if (i < provider.categories.length) {
                                final category = provider.categories[i];
                                final isSelected =
                                    provider.selectedCategory == category.title;
                                return GestureDetector(
                                  onTap: () =>
                                      provider.selectCategory(category.title),
                                  child: Chip(
                                    label: Text(
                                      category.title,
                                      style: TextStyle(
                                        fontSize: Responsive.getSmallFontSize(
                                          context,
                                        ),
                                      ),
                                    ),
                                    backgroundColor: isSelected
                                        ? const Color(0xFFE53935)
                                        : null,
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : null,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            separatorBuilder: (_, __) =>
                                SizedBox(width: Responsive.getSpacing(context)),
                            itemCount: provider.categories.length,
                          ),
                        ),
                      ),

                      SliverList.builder(
                        itemCount: provider.filteredFeeds.length,
                        itemBuilder: (_, i) {
                          final feed = provider.filteredFeeds[i];
                          return _FeedTile(feed: feed);
                        },
                      ),
                      if (provider.filteredFeeds.isEmpty && !provider.loading)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Text(
                                'No videos available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, HomeProvider provider) {
    final now = DateTime.now();
    final hour = now.hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    final displayName = provider.userName?.isNotEmpty == true
        ? provider.userName!
        : 'User';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          greeting,
          style: TextStyle(
            fontSize: Responsive.getSmallFontSize(context),
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 4),
        Text(
          displayName,
          style: TextStyle(
            fontSize: Responsive.getTitleFontSize(context),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _FeedTile extends StatelessWidget {
  const _FeedTile({required this.feed});
  final FeedModel feed;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
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
        onTap: () => context.read<HomeProvider>().play(feed),
        child: AspectRatio(
          aspectRatio: Responsive.getAspectRatio(context),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (feed.thumbnailUrl != null)
                Image.network(feed.thumbnailUrl!, fit: BoxFit.cover)
              else
                Container(color: Colors.black12),
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(
                    Icons.play_arrow,
                    size: Responsive.getIconSize(context),
                  ),
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
              CircleAvatar(radius: Responsive.getAvatarRadius(context)),
              SizedBox(width: Responsive.getSpacing(context)),
              Expanded(
                child: Text(
                  feed.user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.getBodyFontSize(context),
                  ),
                ),
              ),
              if (isPlaying)
                IconButton(
                  onPressed: () => context.read<HomeProvider>().pause(),
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
            style: TextStyle(fontSize: Responsive.getBodyFontSize(context)),
          ),
          Divider(
            height: Responsive.getSpacing(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
          ),
        ],
      ),
    );
  }
}
