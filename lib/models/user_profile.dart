class UserProfile {
   String fullName;
   String username;
   String email;
   String phoneNumber;
   String countryCode;
   String nid;
   String dob;
   String? gender;
   bool isPremium; // ✅ New field added

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
