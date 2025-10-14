import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/storage/token_storage.dart';
import '../../../core/utils/responsive.dart';
import '../data/add_feed_service.dart';
import '../state/add_feed_provider.dart';

class AddFeedScreen extends StatefulWidget {
  const AddFeedScreen({super.key});

  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  bool _showAllCategories = false;
  static const int _maxVisibleCategories = 6;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AddFeedProvider(AddFeedService(), TokenStorage())..loadCategories(),
      child: Consumer<AddFeedProvider>(
        builder: (context, p, _) => Scaffold(
          backgroundColor: const Color(0xFF1A1A1A), // Dark background
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A1A1A),
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            title: Text(
              'Add Feeds',
              style: TextStyle(
                color: Colors.white,
                fontSize: Responsive.getTitleFontSize(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                child: ElevatedButton(
                  onPressed: p.canSubmit
                      ? () async {
                          final ok = await p.submit();
                          if (!context.mounted) return;
                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Uploaded successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(p.error ?? 'Upload failed'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935), // Reddish-brown
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Share Post',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Progress Indicator at the top
              if (p.loading)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  color: const Color(0xFF2A2A2A),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: p.total == 0 ? null : p.uploaded / p.total,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFE53935),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Uploading... ${p.total > 0 ? '${(p.uploaded / p.total * 100).toInt()}%' : ''}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: Responsive.getAllPadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video Upload Section
                      _buildVideoUploadSection(context, p),
                      SizedBox(
                        height: Responsive.getSpacing(
                          context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        ),
                      ),

                      // Thumbnail Upload Section
                      _buildThumbnailUploadSection(context, p),
                      SizedBox(
                        height: Responsive.getSpacing(
                          context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        ),
                      ),

                      // Description Section
                      _buildDescriptionSection(context, p),
                      SizedBox(
                        height: Responsive.getSpacing(
                          context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        ),
                      ),

                      // Categories Section
                      _buildCategoriesSection(context, p),
                      SizedBox(
                        height: Responsive.getSpacing(
                          context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoUploadSection(BuildContext context, AddFeedProvider p) {
    return Container(
      height: Responsive.getVideoHeight(context),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(
          Responsive.getBorderRadius(context),
        ),
      ),
      child: InkWell(
        onTap: p.pickVideo,
        borderRadius: BorderRadius.circular(
          Responsive.getBorderRadius(context),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Responsive.getBorderRadius(context),
            ),
            border: Border.all(
              color: Colors.white,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (p.videoFile != null) ...[
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFE53935),
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  p.videoFile!.path.split('/').last,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Select a video from Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailUploadSection(BuildContext context, AddFeedProvider p) {
    return Container(
      height: Responsive.getButtonHeight(
        context,
        mobile: 70,
        tablet: 80,
        desktop: 90,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(
          Responsive.getBorderRadius(context),
        ),
      ),
      child: InkWell(
        onTap: p.pickImage,
        borderRadius: BorderRadius.circular(
          Responsive.getBorderRadius(context),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Responsive.getBorderRadius(context),
            ),
            border: Border.all(
              color: Colors.white,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              if (p.imageFile != null) ...[
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFE53935),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    p.imageFile!.path.split('/').last,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ] else ...[
                const Icon(Icons.image_outlined, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                const Text(
                  'Add a Thumbnail',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, AddFeedProvider p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Description',
          style: TextStyle(
            color: Colors.white,
            fontSize: Responsive.getTitleFontSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Responsive.getSpacing(context)),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(
              Responsive.getBorderRadius(context),
            ),
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: TextField(
            controller: p.descController,
            maxLines: 4,
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.getBodyFontSize(context),
            ),
            decoration: InputDecoration(
              hintText: 'Add Description',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: Responsive.getBodyFontSize(context),
              ),
              border: InputBorder.none,
              contentPadding: Responsive.getAllPadding(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),
            onChanged: (v) => p.desc = v,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context, AddFeedProvider p) {
    final visibleCategories = _showAllCategories
        ? p.categories
        : p.categories.take(_maxVisibleCategories).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories This Project',
              style: TextStyle(
                color: Colors.white,
                fontSize: Responsive.getTitleFontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (p.categories.length > _maxVisibleCategories)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllCategories = !_showAllCategories;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _showAllCategories ? 'Show Less' : 'View All',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.getSmallFontSize(context),
                      ),
                    ),
                    SizedBox(
                      width: Responsive.getSpacing(
                        context,
                        mobile: 4,
                        tablet: 6,
                        desktop: 8,
                      ),
                    ),
                    Icon(
                      _showAllCategories
                          ? Icons.keyboard_arrow_up
                          : Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: Responsive.getSmallFontSize(context),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: Responsive.getSpacing(context)),
        if (p.categoriesLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
              ),
            ),
          )
        else if (p.error != null && p.categories.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[900]?.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              'Failed to load categories: ${p.error}',
              style: const TextStyle(color: Colors.red),
            ),
          )
        else if (p.categories.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'No categories found',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          Wrap(
            spacing: Responsive.getSpacing(context),
            runSpacing: Responsive.getSpacing(context),
            children: [
              for (final c in visibleCategories)
                FilterChip(
                  label: Text(
                    c.title,
                    style: TextStyle(
                      color: p.selectedCategories.contains(c.id)
                          ? Colors.white
                          : const Color(0xFFE53935),
                      fontSize: Responsive.getSmallFontSize(context),
                    ),
                  ),
                  selected: p.selectedCategories.contains(c.id),
                  onSelected: (_) => p.toggleCategory(c.id),
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0xFFE53935),
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: p.selectedCategories.contains(c.id)
                        ? const Color(0xFFE53935)
                        : Colors.white,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.getBorderRadius(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
