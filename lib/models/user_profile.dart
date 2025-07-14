class UserProfile {
   String fullName;
   String username;
   String email;
   String phoneNumber;
   String countryCode;
   String nid;
   String dob;
   String? gender;
   final bool isPremium;

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
      nid: json['nid'],
      dob: json['dob'],
      gender: json['gender'],
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
      'nid': nid,
      'dob': dob,
      'gender': gender,
      'is_premium': isPremium,
    };
  }
}
