import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void clearProfile() {
    _userProfile = null;
    notifyListeners();
  }

  /// ✅ Add this method to update premium status
  Future<void> updatePremiumStatus(bool status) async {
    if (_userProfile != null) {
      _userProfile = UserProfile(
        fullName: _userProfile!.fullName,
        username: _userProfile!.username,
        email: _userProfile!.email,
        phoneNumber: _userProfile!.phoneNumber,
        countryCode: _userProfile!.countryCode,
        nid: _userProfile!.nid,
        dob: _userProfile!.dob,
        gender: _userProfile!.gender,
        isPremium: status, // 👈 update here
      );
      notifyListeners();
    }
  }

  /// Optional helper:
  bool get isPremium => _userProfile?.isPremium ?? false;
}
