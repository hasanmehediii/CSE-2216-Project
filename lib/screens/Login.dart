import 'package:flutter/material.dart';
import '../common/custom_text_field.dart';
import 'Home.dart';
import 'SignUp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  // Create a GlobalKey for form validation
  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? mail) {
    if (mail == null || mail.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(mail)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey, // Set the global key for the form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Icon (Optional)
                const Icon(
                  Icons.lock_open,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 40),
                // Email Field
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 20),
                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscureText,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  validator: _validatePassword,
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 30),
                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(
                            userName: _emailController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                // SignUp Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
