import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cseduapp/screens/About.dart';
import 'package:cseduapp/screens/Login.dart';
import 'firebase_options.dart';
import 'dart:io' show Platform, exit;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'providers/user_profile_provider.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'screens/Home.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: const LanguageLearningApp(),
    ),
  );
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
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/about': (context) => const AboutUsPage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data == true ? const HomeScreen() : const WelcomeScreen();
      },
    );
  }

  Future<bool> _checkLoginStatus(BuildContext context) async {
    final token = await StorageService.getToken();
    if (token != null) {
      try {
        final profile = await AuthService().fetchUserProfile(token);
        Provider.of<UserProfileProvider>(context, listen: false)
            .setUserProfile(profile);
        await StorageService.saveUserProfile(profile);
        return true;
      } catch (e) {
        print('Auto-login failed: $e');
        await StorageService.clearStorage(); // Clear invalid token
        return false;
      }
    }
    return false;
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
              Positioned(top: _animation.value, left: _animation.value, child: _buildFadedLetter('A')),
              Positioned(top: 100 + _animation.value, right: 20 + _animation.value, child: _buildFadedLetter('あ')),
              Positioned(bottom: 100 - _animation.value, left: 20 + _animation.value, child: _buildFadedLetter('ب')),
              Positioned(bottom: 50 + _animation.value, right: 50 - _animation.value, child: _buildFadedLetter('文')),
              Positioned(top: 30 + _animation.value, right: 100 - _animation.value, child: _buildFadedLetter('अ')),
              Positioned(top: 200 - _animation.value, left: 80 + _animation.value, child: _buildFadedLetter('অ')),
              Positioned(bottom: 200 + _animation.value, right: 70 - _animation.value, child: _buildFadedLetter('ñ')),
              Positioned(top: 250 + _animation.value, left: 50 - _animation.value, child: _buildFadedLetter('é')),

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
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Your buddy for language learning!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      const SizedBox(height: 40),

                      // Get Started Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Get Started"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // About Us Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/about');
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text("About Us"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Exit Button with confirmation dialog
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showExitDialog(context);
                          },
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

  Widget _buildFadedLetter(String letter) {
    return Opacity(
      opacity: 0.04,
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

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
                // Show a message or redirect
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exit is not supported on Web')),
                );
              } else if (Platform.isAndroid || Platform.isIOS) {
                // On mobile, pop the app
                Navigator.of(context).maybePop();
              } else {
                // On desktop
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
