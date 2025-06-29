import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';
import '../services/storage_service.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;
  bool get isPremium => _userProfile?.isPremium ?? false;

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void clearUserProfile() {
    _userProfile = null;
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    final token = await StorageService.getToken();
    if (token == null) {
      throw Exception('No authentication token available');
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.103:8000/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        _userProfile = UserProfile.fromJson(userData);
        await StorageService.saveUserProfile(_userProfile!);
        notifyListeners();
      } else {
        throw Exception('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  Future<void> updatePremiumStatus(bool isPremium) async {
    final token = await StorageService.getToken();
    if (token == null) {
      throw Exception('No authentication token available');
    }

    try {
      final response = await http.patch(
        Uri.parse('http://192.168.0.103:8000/user/premium'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'is_premium': isPremium}),
      );

      if (response.statusCode == 200) {
        _userProfile = UserProfile(
          fullName: _userProfile!.fullName,
          username: _userProfile!.username,
          email: _userProfile!.email,
          phoneNumber: _userProfile!.phoneNumber,
          countryCode: _userProfile!.countryCode,
          gender: _userProfile!.gender,
          nid: _userProfile!.nid,
          dob: _userProfile!.dob,
          isPremium: isPremium,
        );
        await StorageService.saveUserProfile(_userProfile!);
        notifyListeners();
      } else {
        throw Exception('Failed to update premium status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating premium status: $e');
    }
  }
}