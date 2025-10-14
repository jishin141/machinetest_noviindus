import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class AddFeedService {
  AddFeedService({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiClient.baseUrl));
  final Dio _dio;

  Future<Map<String, dynamic>> upload({
    required String token,
    required File video,
    required File image,
    required String desc,
    required List<int> categoryIds,
    required void Function(int sent, int total) onProgress,
  }) async {
    // Try different field name variations that might be expected by the API
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        video.path,
        filename: video.uri.pathSegments.last,
      ),
      'image': await MultipartFile.fromFile(
        image.path,
        filename: image.uri.pathSegments.last,
      ),
      'desc': desc,
      'category': categoryIds,
    });

    print('FormData fields:');
    print('- video: ${video.path} (${video.lengthSync()} bytes)');
    print('- image: ${image.path} (${image.lengthSync()} bytes)');
    print('- desc: $desc');
    print('- category: $categoryIds');

    print('Uploading feed with:');
    print('- Video: ${video.path}');
    print('- Image: ${image.path}');
    print('- Description: $desc');
    print('- Categories: $categoryIds');

    try {
      final response = await _dio.post(
        'my_feed',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(
            minutes: 5,
          ), // 5 minute timeout for upload
          receiveTimeout: const Duration(
            minutes: 2,
          ), // 2 minute timeout for response
        ),
        onSendProgress: onProgress,
      );

      print('Upload response status: ${response.statusCode}');
      print('Upload response data: ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Upload failed with status ${response.statusCode}: ${response.data}',
        );
      }

      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Upload error details: $e');
      if (e is DioException) {
        print('Dio error type: ${e.type}');
        print('Dio error response: ${e.response?.data}');
        print('Dio error message: ${e.message}');

        // Handle specific error types
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            throw Exception(
              'Connection timeout. Please check your internet connection and try again.',
            );
          case DioExceptionType.sendTimeout:
            throw Exception(
              'Upload timeout. The file might be too large. Please try again.',
            );
          case DioExceptionType.receiveTimeout:
            throw Exception('Server response timeout. Please try again.');
          case DioExceptionType.connectionError:
            throw Exception(
              'Connection error. Please check your internet connection and try again.',
            );
          case DioExceptionType.badResponse:
            throw Exception(
              'Server error (${e.response?.statusCode}). Please try again later.',
            );
          case DioExceptionType.cancel:
            throw Exception('Upload was cancelled.');
          case DioExceptionType.unknown:
            if (e.message?.contains('Connection reset by peer') == true) {
              throw Exception(
                'Connection lost during upload. Please check your internet connection and try again.',
              );
            } else if (e.message?.contains('SocketException') == true) {
              throw Exception(
                'Network error. Please check your internet connection and try again.',
              );
            }
            throw Exception('Upload failed: ${e.message ?? 'Unknown error'}');
          default:
            throw Exception('Upload failed: ${e.message ?? 'Unknown error'}');
        }
      }
      rethrow;
    }
  }
}
