import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../screens/Home.dart';

class AuthService {
  final String baseUrl = 'http://127.0.0.1:8000';


  Future<void> signUp({
    required String fullName,
    required String username,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String gender,
    required String nid,
    required String dob,
    required String password,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/signup');

    final body = jsonEncode({
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'gender': gender,
      'nid': nid,
      'dob': dob,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Signup success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Signup failed
        final resBody = jsonDecode(response.body);
        final errorMessage = resBody['detail'] ?? 'Sign Up Failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Network or other error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
