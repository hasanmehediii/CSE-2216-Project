import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../screens/Home.dart';
import '../models/user_profile.dart'; // Ensure UserProfile model has fromJson
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  // SignUp method (unchanged, included for completeness)
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

      print('SignUp response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        final resBody = jsonDecode(response.body);
        final errorMessage = resBody['detail'] ?? 'Sign Up Failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('SignUp error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // New login method
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Login response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'token': data['token'],
          'profile': UserProfile.fromJson(data['profile']),
        };
      } else {
        final resBody = jsonDecode(response.body);
        final errorMessage = resBody['detail'] ?? 'Login Failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }
}