import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cseduapp/screens/About.dart';
import 'package:cseduapp/screens/Login.dart';
import 'package:cseduapp/screens/Home.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/user_profile_provider.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'screens/que_screen.dart';
import 'screens/result_screen.dart';
import '../screens/home_screens/video_lessons.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // Show SplashScreen first
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/about': (context) => const AboutUsPage(),
        '/mcq': (context) => const QuestionScreen(),
        '/result': (context) => const ResultScreen(score: 0, total: 0, day: 0), // placeholder
        '/video': (context) => const VideoLessonsPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds and then navigate to the WelcomeScreen
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text "LangBuddy" above the image
            const Text(
              'LangBuddy',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Splash screen image (icon)
            Image.asset(
              'assets/splash.png', // Ensure the splash.png is placed in your assets folder
              width: 150, // You can adjust the width as per your design requirement
              height: 150,
            ),
            const SizedBox(height: 20),
            // Text below the image
            const Text(
              'World\'s Best Language Learning App',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
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
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
        Provider.of<UserProfileProvider>(context, listen: false).setUserProfile(profile);
        await StorageService.saveUserProfile(profile);
        return true;
      } catch (e) {
        await StorageService.clearStorage();
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
                      _buildButton(
                        context,
                        label: "Get Started",
                        icon: Icons.arrow_forward,
                        color: Colors.blueAccent,
                        route: '/login',
                      ),
                      const SizedBox(height: 20),

                      // About Us Button
                      _buildButton(
                        context,
                        label: "About Us",
                        icon: Icons.info_outline,
                        color: Colors.lightBlue,
                        route: '/about',
                      ),
                      const SizedBox(height: 20),

                      // Exit Button
                      _buildButton(
                        context,
                        label: "Exit",
                        icon: Icons.exit_to_app,
                        color: Colors.redAccent,
                        onPressed: () => _showExitDialog(context),
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

  Widget _buildButton(BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    String? route,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed ?? () => Navigator.pushNamed(context, route!),
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
