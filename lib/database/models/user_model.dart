class AppUser {
  final String uid;
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String gender;
  final String nid;
  final String dob;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.gender,
    required this.nid,
    required this.dob,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'gender': gender,
      'nid': nid,
      'dob': dob,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      fullName: map['fullName'],
      username: map['username'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      countryCode: map['countryCode'],
      gender: map['gender'],
      nid: map['nid'],
      dob: map['dob'],
    );
  }
}