import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../common/custom_text_field.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'SignUp.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../models/user_profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _userEmailController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _userFormKey = GlobalKey<FormState>();
  final _adminFormKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _isLoggingIn = false;
  int _loginMode = 0;
  final PageController _pageController = PageController(initialPage: 0);

  late AnimationController _bgController;
  late Animation<double> _bgAnimation;
  late AnimationController _exitAnimationController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOutSine),
    );

    _exitAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _exitAnimationController.dispose();
    _userEmailController.dispose();
    _adminEmailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? mail) {
    if (mail == null || mail.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(mail)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Please enter your password';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _login() async {
    final currentFormKey = _loginMode == 0 ? _userFormKey : _adminFormKey;
    if (currentFormKey.currentState?.validate() ?? false) {
      setState(() => _isLoggingIn = true);

      try {
        final email = _loginMode == 0 ? _userEmailController.text.trim() : _adminEmailController.text.trim();
        final password = _passwordController.text.trim();

        if (_loginMode == 1) {
          if (email == "admin@gmail.com" && password == "admin1234") {
            await StorageService.saveToken("admin-token");
            final adminProfile = UserProfile(
              fullName: "LangMastero Admin",
              username: "admin",
              email: "admin@gmail.com",
              phoneNumber: "00000000000",
              countryCode: "+88",
              gender: "Other",
              nid: "0000000000",
              dob: "2000-01-01",
              isPremium: true,
            );

            await StorageService.saveUserProfile(adminProfile);
            Provider.of<UserProfileProvider>(context, listen: false).setUserProfile(adminProfile);

            await _exitAnimationController.forward();
            Navigator.pushReplacementNamed(context, '/admin');
            return;
          } else {
            throw Exception("Invalid admin credentials");
          }
        }

        final authService = AuthService();
        final result = await authService.login(email, password);

        await StorageService.saveToken(result['token']);
        await StorageService.saveUserProfile(result['profile']);
        Provider.of<UserProfileProvider>(context, listen: false).setUserProfile(result['profile']);

        await _exitAnimationController.forward();
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() => _isLoggingIn = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e", style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.redAccent,
          ),
        );
        print("Login failed: $e");
      }
    }
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _isLoggingIn ? null : _login,
        child: _isLoggingIn
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildUserLoginForm() {
    return Form(
      key: _userFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: _userEmailController,
            hintText: 'Email',
            prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            focusNode: _emailFocusNode,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            hintText: 'Password',
            obscureText: _obscureText,
            prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.blueAccent,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
            validator: _validatePassword,
            focusNode: _passwordFocusNode,
          ),
          const SizedBox(height: 24),
          _buildLoginButton(),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignUpPage()),
            ),
            child: const Text(
              "Don't have an account? Sign Up",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminLoginForm() {
    return Form(
      key: _adminFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: _adminEmailController,
            hintText: 'Admin Email',
            prefixIcon: const Icon(Icons.admin_panel_settings, color: Colors.blueAccent),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            focusNode: _emailFocusNode,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            hintText: 'Admin Password',
            obscureText: _obscureText,
            prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.blueAccent,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
            validator: _validatePassword,
            focusNode: _passwordFocusNode,
          ),
          const SizedBox(height: 24),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildFadedLetter(String letter) {
    return Opacity(
      opacity: 0.03,
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 80,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'LangMastero',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(top: _bgAnimation.value, left: _bgAnimation.value, child: _buildFadedLetter('A')),
                  Positioned(top: 120 + _bgAnimation.value, right: 30 + _bgAnimation.value, child: _buildFadedLetter('あ')),
                  Positioned(bottom: 120 - _bgAnimation.value, left: 30 + _bgAnimation.value, child: _buildFadedLetter('ب')),
                  Positioned(bottom: 60 + _bgAnimation.value, right: 60 - _bgAnimation.value, child: _buildFadedLetter('文')),
                  Positioned(top: 40 + _bgAnimation.value, right: 120 - _bgAnimation.value, child: _buildFadedLetter('अ')),
                  Positioned(top: 220 - _bgAnimation.value, left: 100 + _bgAnimation.value, child: _buildFadedLetter('অ')),
                  Positioned(bottom: 220 + _bgAnimation.value, right: 90 - _bgAnimation.value, child: _buildFadedLetter('ñ')),
                  Positioned(top: 280 + _bgAnimation.value, left: 60 - _bgAnimation.value, child: _buildFadedLetter('é')),
                ],
              );
            },
          ),
          Center(
            child: ScaleTransition(
              scale: Tween<double>(begin: 1, end: 0).animate(
                CurvedAnimation(parent: _exitAnimationController, curve: Curves.easeInOut),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue[50]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
                    constraints: BoxConstraints(
                      maxWidth: 400,
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: Lottie.asset(
                              _loginMode == 0
                                  ? 'assets/gifs/loginn.json'
                                  : 'assets/gifs/admin_office.json',
                              repeat: true,
                              fit: BoxFit.contain,
                              frameRate: FrameRate(60),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              Text(
                                'Login to Continue',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  fontSize: 26,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ToggleButtons(
                                isSelected: [_loginMode == 0, _loginMode == 1],
                                onPressed: (index) {
                                  setState(() {
                                    _loginMode = index;
                                    _userEmailController.clear();
                                    _adminEmailController.clear();
                                    _passwordController.clear();
                                    _userFormKey.currentState?.reset();
                                    _adminFormKey.currentState?.reset();
                                  });
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                selectedColor: Colors.white,
                                fillColor: Colors.blueAccent,
                                color: Colors.blueAccent,
                                selectedBorderColor: Colors.blueAccent,
                                borderColor: Colors.blue[200],
                                constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
                                children: const [
                                  Text("User", style: TextStyle(fontWeight: FontWeight.w600)),
                                  Text("Admin", style: TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 380,
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildUserLoginForm(),
                                _buildAdminLoginForm(),
                              ],
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
        ],
      ),
    );
  }
}