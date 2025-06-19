import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  // Save JWT token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Get JWT token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Save user profile
  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', jsonEncode(profile.toJson()));
  }

  // Get user profile
  static Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString('user_profile');
    if (profileString != null) {
      return UserProfile.fromJson(jsonDecode(profileString));
    }
    return null;
  }

  // Clear storage on logout
  static Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
    await _storage.delete(key: 'auth_token');
  }
}