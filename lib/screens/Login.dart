import 'package:cseduapp/screens/welcome_page.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'Home.dart';
import 'SignUp.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Login"),
              onPressed: () {
                // Navigate to Home or Dashboard screen
                // For now, we show a simple alert
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WelcomePage(fullName: "Mehedi", email: "mehedi@gmail.com", gender: "boy", dob: "12/2/4505")),
                );
              },
            ),
            TextButton(
              child: Text("SignUp"),
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text("Password reset functionality not implemented yet.")),
                // );

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignUpPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

