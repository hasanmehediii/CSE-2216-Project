import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/Home.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up method
  Future<void> signUp({
    required String fullName,
    required String username,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String gender,
    required DateTime dob,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user info to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'fullName': fullName,
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'countryCode': countryCode,
        'gender': gender,
        'dob': dob,
        'profilePicture': '', // Optional: Add logic to upload profile picture
      });

      // Navigate to HomeScreen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userName: username)),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Sign Up Failed')),
      );
    }
  }
}
