import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../core/storage/token_storage.dart';
import '../../home/data/home_service.dart';
import '../../home/data/models.dart';
import '../data/add_feed_service.dart';

class AddFeedProvider extends ChangeNotifier {
  AddFeedProvider(this._service, this._storage) : _homeService = HomeService();
  final AddFeedService _service;
  final TokenStorage _storage;
  final HomeService _homeService;

  File? videoFile;
  File? imageFile;
  String desc = '';
  final TextEditingController descController = TextEditingController();
  final List<String> selectedCategories = [];
  List<CategoryModel> categories = [];
  bool categoriesLoading = false;

  int uploaded = 0;
  int total = 0;
  bool loading = false;
  String? error;

  Future<void> loadCategories() async {
    categoriesLoading = true;
    error = null;
    notifyListeners();
    try {
      // Get categories from home API (category_dict) + additional categories from category_list
      final homeData = await _homeService.fetchHomeData();
      final homeCategories = (homeData['category_dict'] as List?) ?? [];
      final additionalCategories = await _homeService
          .fetchAdditionalCategories();

      // Combine both lists and remove duplicates
      final allCategories = <CategoryModel>[];
      final seenTitles = <String>{};

      // Add home categories first
      for (final e in homeCategories) {
        final category = CategoryModel.fromJson(e as Map<String, dynamic>);
        if (!seenTitles.contains(category.title)) {
          allCategories.add(category);
          seenTitles.add(category.title);
        }
      }

      // Add additional categories, skipping duplicates
      for (final category in additionalCategories) {
        if (!seenTitles.contains(category.title)) {
          allCategories.add(category);
          seenTitles.add(category.title);
        }
      }

      categories = allCategories;
    } catch (e) {
      error = e.toString();
    } finally {
      categoriesLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final x = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );
    if (x == null) return;
    if (!x.path.toLowerCase().endsWith('.mp4')) {
      error = 'Only MP4 videos are allowed';
      notifyListeners();
      return;
    }
    videoFile = File(x.path);
    // optional duration check via VideoPlayerController
    final ctrl = VideoPlayerController.file(videoFile!);
    await ctrl.initialize();
    if (ctrl.value.duration > const Duration(minutes: 5)) {
      error = 'Max duration is 5 minutes';
      await ctrl.dispose();
      videoFile = null;
      notifyListeners();
      return;
    }
    await ctrl.dispose();
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x == null) return;
    imageFile = File(x.path);
    notifyListeners();
  }

  void toggleCategory(String id) {
    if (selectedCategories.contains(id)) {
      selectedCategories.remove(id);
    } else {
      selectedCategories.add(id);
    }
    notifyListeners();
  }

  bool get canSubmit =>
      !loading &&
      videoFile != null &&
      imageFile != null &&
      descController.text.trim().isNotEmpty &&
      selectedCategories.isNotEmpty;

  void clearForm() {
    videoFile = null;
    imageFile = null;
    desc = '';
    descController.clear();
    selectedCategories.clear();
    error = null;
    loading = false;
    uploaded = 0;
    total = 0;
    notifyListeners();
  }

  Future<bool> submit({int retryCount = 0}) async {
    if (!canSubmit) {
      error = 'Please fill all fields';
      notifyListeners();
      return false;
    }
    loading = true;
    error = null;
    uploaded = 0;
    total = 0;
    notifyListeners();
    try {
      final token = await _storage.readToken();
      if (token == null || token.isEmpty) {
        error = 'Not authenticated';
        return false;
      }

      final categoryIds = selectedCategories.map((id) {
        // Convert string IDs to integers, handling both "22" and "0.01" formats
        if (id.contains('.')) {
          // For home API categories like "0.01", "0.0", "0", use a default value
          return 0;
        }
        return int.tryParse(id) ?? 0;
      }).toList();

      print(
        'Submitting with categories: $selectedCategories -> $categoryIds (attempt ${retryCount + 1})',
      );

      final response = await _service.upload(
        token: token,
        video: videoFile!,
        image: imageFile!,
        desc: descController.text,
        categoryIds: categoryIds,
        onProgress: (s, t) {
          uploaded = s;
          total = t;
          notifyListeners();
        },
      );

      print('Upload successful: $response');

      // Clear form after successful upload
      clearForm();

      return true;
    } catch (e) {
      print('Upload error: $e');

      // Check if we should retry (network errors only)
      final errorMessage = e.toString();
      final shouldRetry =
          retryCount < 2 &&
          (errorMessage.contains('Connection reset by peer') ||
              errorMessage.contains('SocketException') ||
              errorMessage.contains('Connection timeout') ||
              errorMessage.contains('Connection error') ||
              errorMessage.contains('Network error'));

      if (shouldRetry) {
        print('Retrying upload... (attempt ${retryCount + 2})');
        await Future.delayed(
          Duration(seconds: 2 * (retryCount + 1)),
        ); // Exponential backoff
        return await submit(retryCount: retryCount + 1);
      }

      error = errorMessage;
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }
}
