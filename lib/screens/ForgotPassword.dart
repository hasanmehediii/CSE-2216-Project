// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ForgetPassword extends StatefulWidget {
//   const ForgetPassword({super.key});
//
//   @override
//   State<ForgetPassword> createState() => _ForgetPasswordState();
// }
//
// class _ForgetPasswordState extends State<ForgetPassword> {
//   final _emailController = TextEditingController();
//   final _nidController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//
//   // Function to handle password reset and auto-login
//   Future<void> _resetPassword() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       final email = _emailController.text.trim();
//       final nid = _nidController.text.trim();
//       final phone = _phoneController.text.trim();
//
//       final url = Uri.parse('http://192.168.3.107:8000/forgot-password');
//       final response = await http.post(url, body: jsonEncode({
//         'email': email,
//         'nid': nid,
//         'phone_number': phone,
//       }), headers: {'Content-Type': 'application/json'});
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         // Save token to SharedPreferences for auto-login
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString('access_token', data['access_token']);
//
//         // Navigate to homepage (after successful login)
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         final error = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error['detail'] ?? 'Something went wrong')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forgot Password'),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _nidController,
//                 decoration: const InputDecoration(labelText: 'NID'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your NID';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(labelText: 'Phone Number'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _resetPassword, // Disable button while loading
//                 child: _isLoading
//                     ? const CircularProgressIndicator()  // Show loading spinner
//                     : const Text('Reset Password'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
