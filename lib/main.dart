import 'dart:io';

import 'package:cseduapp/screens/Login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(LanguageLearningApp());
}

class LanguageLearningApp extends StatelessWidget {
  const LanguageLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.language, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Welcome to LangBuddy",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Your buddy for language learning",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 40),
            // Get Started Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Text("Get Started"),
            ),
            SizedBox(height: 20),
            // About Us Button
            ElevatedButton(
              onPressed: () {
                // Action for About Us Button
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("About Us"),
                      content: Text(
                          "This is an app to help you learn new languages easily. Stay tuned for more features."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("About Us"),
            ),
            SizedBox(height: 20),
            // Exit Button
            ElevatedButton(
              onPressed: () {
                // Exit the app
                exit(0);
              },
              child: Text("Exit"),
            ),
          ],
        ),
      ),
    );
  }
}
