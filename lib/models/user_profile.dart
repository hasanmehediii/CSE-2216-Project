class UserProfile {
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String? gender;
  final String nid;
  final String dob;
  final bool isPremium; // Add isPremium field

  UserProfile({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    this.gender,
    required this.nid,
    required this.dob,
    required this.isPremium,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      gender: json['gender'],
      nid: json['nid'],
      dob: json['dob'],
      isPremium: json['is_premium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'gender': gender,
      'nid': nid,
      'dob': dob,
      'is_premium': isPremium,
    };
  }
}