import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../common/custom_text_field.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'SignUp.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _isLoggingIn = false;

  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  late AnimationController _exitAnimationController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );

    _exitAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _exitAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String? mail) {
    if (mail == null || mail.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(mail)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Please enter your password';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoggingIn = true);
      try {
        final authService = AuthService();
        final result = await authService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        await StorageService.saveToken(result['token']);
        await StorageService.saveUserProfile(result['profile']);
        Provider.of<UserProfileProvider>(context, listen: false).setUserProfile(result['profile']);

        await _exitAnimationController.forward();
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() => _isLoggingIn = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('LangBuddy'),
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Animated moving faded letters in background
          AnimatedBuilder(
            animation: _bgAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(top: _bgAnimation.value, left: _bgAnimation.value, child: _buildFadedLetter('A')),
                  Positioned(top: 100 + _bgAnimation.value, right: 20 + _bgAnimation.value, child: _buildFadedLetter('あ')),
                  Positioned(bottom: 100 - _bgAnimation.value, left: 20 + _bgAnimation.value, child: _buildFadedLetter('ب')),
                  Positioned(bottom: 50 + _bgAnimation.value, right: 50 - _bgAnimation.value, child: _buildFadedLetter('文')),
                  Positioned(top: 30 + _bgAnimation.value, right: 100 - _bgAnimation.value, child: _buildFadedLetter('अ')),
                  Positioned(top: 200 - _bgAnimation.value, left: 80 + _bgAnimation.value, child: _buildFadedLetter('অ')),
                  Positioned(bottom: 200 + _bgAnimation.value, right: 70 - _bgAnimation.value, child: _buildFadedLetter('ñ')),
                  Positioned(top: 250 + _bgAnimation.value, left: 50 - _bgAnimation.value, child: _buildFadedLetter('é')),
                ],
              );
            },
          ),

          // Login Card UI
          Center(
            child: ScaleTransition(
              scale: Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
                parent: _exitAnimationController,
                curve: Curves.easeInOut,
              )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Cartoon logo animation
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: Lottie.asset(
                                'assets/gifs/loginn.json', // replace with your actual file
                                repeat: true,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Login to Continue',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                            const SizedBox(height: 30),
                            CustomTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                              focusNode: _emailFocusNode,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              obscureText: _obscureText,
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                onPressed: () => setState(() => _obscureText = !_obscureText),
                              ),
                              validator: _validatePassword,
                              focusNode: _passwordFocusNode,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  elevation: 8,
                                  shadowColor: Colors.black.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: _isLoggingIn ? null : _login,
                                child: _isLoggingIn
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Login', style: TextStyle(fontSize: 20, color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignUpPage()),
                              ),
                              child: const Text(
                                "Don't have an account? Sign Up",
                                style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFadedLetter(String letter) {
    return Opacity(
      opacity: 0.05,
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
}
