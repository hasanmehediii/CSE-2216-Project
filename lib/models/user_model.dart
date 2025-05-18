import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String gender;
  final DateTime dob;
  final String profilePicture;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.gender,
    required this.dob,
    required this.profilePicture,
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
      'dob': dob,
      'profilePicture': profilePicture,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      username: map['username'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      countryCode: map['countryCode'],
      gender: map['gender'],
      dob: (map['dob'] as Timestamp).toDate(),
      profilePicture: map['profilePicture'] ?? '',
    );
  }
}
