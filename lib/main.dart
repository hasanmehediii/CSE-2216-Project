import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cseduapp/screens/About.dart';
import 'package:cseduapp/screens/Login.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LanguageLearningApp());
}

class LanguageLearningApp extends StatelessWidget {
  const LanguageLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/about': (context) => const AboutUsPage(),
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LangBuddy'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Floating faded letters
              _floatingLetter('A', top: _animation.value, left: _animation.value),
              _floatingLetter('あ', top: 100 + _animation.value, right: 20 + _animation.value),
              _floatingLetter('ب', bottom: 100 - _animation.value, left: 20 + _animation.value),
              _floatingLetter('文', bottom: 50 + _animation.value, right: 50 - _animation.value),
              _floatingLetter('अ', top: 30 + _animation.value, right: 100 - _animation.value),
              _floatingLetter('অ', top: 200 - _animation.value, left: 80 + _animation.value),
              _floatingLetter('ñ', bottom: 200 + _animation.value, right: 70 - _animation.value),
              _floatingLetter('é', top: 250 + _animation.value, left: 50 - _animation.value),

              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.language, size: 100, color: Colors.blueAccent),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome to LangBuddy",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Your buddy for language learning!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      const SizedBox(height: 40),

                      // Login Button
                      _buildButton(
                        context,
                        label: "Get Started",
                        icon: Icons.arrow_forward,
                        color: Colors.blueAccent,
                        route: '/login',
                      ),

                      const SizedBox(height: 20),

                      // About Button
                      _buildButton(
                        context,
                        label: "About Us",
                        icon: Icons.info_outline,
                        color: Colors.lightBlue,
                        route: '/about',
                      ),
                      const SizedBox(height: 20),

                      // Exit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showExitDialog(context),
                          icon: const Icon(Icons.exit_to_app),
                          label: const Text("Exit"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Floating letter helper
  Widget _floatingLetter(String letter, {double? top, double? left, double? right, double? bottom}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Opacity(
        opacity: 0.04,
        child: Text(
          letter,
          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  // Button builder
  Widget _buildButton(BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  // Exit confirmation
  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (kIsWeb) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exit is not supported on Web')),
                );
              } else if (Platform.isAndroid || Platform.isIOS) {
                Navigator.of(context).maybePop();
              } else {
                exit(0);
              }
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }
}
