import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._storage) : _client = ApiClient();

  final TokenStorage _storage;
  final ApiClient _client;

  bool _loading = false;
  String? _error;
  String? _token;

  bool get loading => _loading;
  String? get error => _error;
  String? get token => _token;

  Future<bool> login({
    required String countryCode,
    required String phone,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final resp = await _client.postForm('otp_verified', {
        'country_code': countryCode,
        'phone': phone,
      });
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = _client.decode(resp) as Map<String, dynamic>;
        // Debug: print response shape for diagnosis
        if (kDebugMode) {
          // ignore: avoid_print
          print('otp_verified response: ' + data.toString());
        }
        final dynamic maybeNested = data['data'];
        // direct keys
        _token = (data['access'] ?? data['access ']) as String?;
        // token nested object { refresh, access }
        if (_token == null) {
          final dynamic tokenObj = data['token'];
          if (tokenObj is Map<String, dynamic>) {
            _token = tokenObj['access'] as String?;
          } else if (tokenObj is String) {
            _token = tokenObj; // fallback if API returned raw token string
          }
        }
        _token ??= data['accessToken'] as String?;
        _token ??= maybeNested is Map<String, dynamic>
            ? (maybeNested['access'] ??
                      maybeNested['token'] ??
                      maybeNested['accessToken'])
                  as String?
            : null;
        if (_token == null || _token!.isEmpty) {
          _error = 'Invalid token';
          return false;
        }
        await _storage.saveToken(_token!);
        return true;
      } else {
        _error = 'Login failed (${resp.statusCode})';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
