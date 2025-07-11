class UserProfile {
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String nid;
  final String dob;
  final String? gender;
  final bool isPremium; // ✅ New field added

  UserProfile({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.nid,
    required this.dob,
    this.gender,
    this.isPremium = false, // ✅ defaulted to false
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      nid: json['nid'],
      dob: json['dob'],
      gender: json['gender'],
      isPremium: json['isPremium'] ?? false, // ✅ null-safe
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'nid': nid,
      'dob': dob,
      'gender': gender,
      'isPremium': isPremium, // ✅ ensure it's saved too
    };
  }
}
