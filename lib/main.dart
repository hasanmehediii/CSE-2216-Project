import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/user_profile_provider.dart';
import 'screens/que_screen.dart';
import 'screens/result_screen.dart';
import 'screens/home_screens/video_lessons.dart';
import 'screens/home_screens/sentence_builder.dart';
import 'package:cseduapp/screens/Login.dart';
import 'package:cseduapp/screens/About.dart';
import 'package:cseduapp/screens/Home.dart';
import 'screens/admin_home_screen.dart';
import 'screens/edit_profile_screen.dart';

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
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminHomeScreen(),
        '/about': (context) => const AboutUsPage(),
        '/mcq': (context) => const QuestionScreen(),
        '/result': (context) => const ResultScreen(score: 0, total: 0, day: 0),
        '/video': (context) => const VideoLessonsPage(),
        '/sentence-builder': (context) => const SentenceBuilderGame(),
        '/edit-profile': (context) => const EditProfileScreen(),
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
            const Text(
              'LangMastero',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/splash.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
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

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Language Learning App'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              _floatingLetter('A', top: _animation.value, left: _animation.value),
              _floatingLetter('あ', top: 100 + _animation.value, right: 20 + _animation.value),
              _floatingLetter('ب', bottom: 100 - _animation.value, left: 20 + _animation.value),
              _floatingLetter('文', bottom: 50 + _animation.value, right: 50 - _animation.value),
              _floatingLetter('अ', top: 30 + _animation.value, right: 100 - _animation.value),
              _floatingLetter('অ', top: 200 - _animation.value, left: 80 + _animation.value),
              _floatingLetter('ñ', bottom: 200 + _animation.value, right: 70 - _animation.value),
              _floatingLetter('é', top: 250 + _animation.value, left: 50 - _animation.value),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset(
                          'assets/gifs/login.json',
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "LangMastero",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black26,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Your buddy for language learning!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildButton(
                        context,
                        label: "Get Started",
                        icon: Icons.arrow_forward,
                        color: Colors.blueAccent,
                        route: '/login',
                      ),
                      const SizedBox(height: 20),
                      _buildButton(
                        context,
                        label: "About Us",
                        icon: Icons.info_outline,
                        color: Colors.lightBlue,
                        route: '/about',
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
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route!),
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          textStyle: const TextStyle(fontSize: 20),
          elevation: 8,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}