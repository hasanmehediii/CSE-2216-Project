import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nidController = TextEditingController();

  String? _selectedCode;
  String? _gender;
  DateTime? _dob;
  bool _acceptedTerms = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Map<String, String>> _countryCodes = [
    {'country': 'United States', 'code': '+1'},
    {'country': 'Bangladesh', 'code': '+88'},
    {'country': 'United Kingdom', 'code': '+44'},
    {'country': 'Australia', 'code': '+61'},
    {'country': 'India', 'code': '+91'},
    {'country': 'Germany', 'code': '+49'},
  ];

  String getFlagEmoji(String country) {
    switch (country) {
      case 'United States': return '🇺🇸';
      case 'Bangladesh': return '🇧🇩';
      case 'United Kingdom': return '🇬🇧';
      case 'Australia': return '🇦🇺';
      case 'India': return '🇮🇳';
      case 'Germany': return '🇩🇪';
      default: return '';
    }
  }

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
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nidController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().signUp(
          fullName: _fullNameController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          countryCode: _selectedCode ?? '',
          gender: _gender,
          nid: _nidController.text.trim(),
          dob: _dob?.toIso8601String() ?? '',
          password: _passwordController.text,
          context: context,
        );
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LangBuddy'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Background faded letters
              Positioned(top: _animation.value, left: _animation.value, child: _buildFadedLetter('A')),
              Positioned(top: 100 + _animation.value, right: 20 + _animation.value, child: _buildFadedLetter('あ')),
              Positioned(bottom: 100 - _animation.value, left: 20 + _animation.value, child: _buildFadedLetter('ب')),
              Positioned(bottom: 50 + _animation.value, right: 50 - _animation.value, child: _buildFadedLetter('文')),
              Positioned(top: 30 + _animation.value, right: 100 - _animation.value, child: _buildFadedLetter('अ')),
              Positioned(top: 200 - _animation.value, left: 80 + _animation.value, child: _buildFadedLetter('অ')),
              Positioned(bottom: 200 + _animation.value, right: 70 - _animation.value, child: _buildFadedLetter('ñ')),
              Positioned(top: 250 + _animation.value, left: 50 - _animation.value, child: _buildFadedLetter('é')),

              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Lottie Animation for Sign Up (placed at the top)
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset(
                          'assets/gifs/loginn.json', // Replace with your actual Lottie JSON file
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Create Your Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                      const SizedBox(height: 30),

                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                        validator: (value) => value == null || value.trim().length < 3 ? "Enter at least 3 characters" : null,
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder()),
                        validator: (value) => value == null || value.trim().isEmpty ? "Username is required" : null,
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                        validator: (value) => value == null || !value.contains('@') || !value.contains('.') ? "Enter a valid email" : null,
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: _selectedCode,
                              decoration: const InputDecoration(labelText: "Code", border: OutlineInputBorder()),
                              items: _countryCodes.map((country) {
                                final code = country['code']!;
                                final flag = getFlagEmoji(country['country']!);
                                return DropdownMenuItem<String>(value: code, child: Text('$flag $code'));
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedCode = value),
                              validator: (value) => value == null ? "Select code" : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()),
                              keyboardType: TextInputType.phone,
                              validator: (value) => value == null || value.trim().isEmpty ? "Phone number is required" : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                        validator: (value) => value == null || value.length < 6 ? "Password must be at least 6 characters" : null,
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _nidController,
                        decoration: const InputDecoration(labelText: "NID Number", border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.trim().length < 10 ? "Enter a valid NID" : null,
                      ),
                      const SizedBox(height: 15),

                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Gender", border: OutlineInputBorder()),
                        items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                        onChanged: (value) => setState(() => _gender = value),
                        validator: (value) => value == null ? "Select gender" : null,
                      ),
                      const SizedBox(height: 15),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(_dob == null ? "Select Date of Birth" : "Date of Birth: \${_dob!.toLocal().toString().split(' ')[0]}"),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) setState(() => _dob = picked);
                        },
                      ),
                      if (_dob == null)
                        const Padding(
                            padding: EdgeInsets.only(left: 8, top: 4),
                            child: Align(alignment: Alignment.centerLeft, child: Text("Date of Birth is required", style: TextStyle(color: Colors.red, fontSize: 12)))),
                      const SizedBox(height: 10),

                      CheckboxListTile(
                        value: _acceptedTerms,
                        onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                        title: const Text("I accept Terms & Conditions"),
                        controlAffinity: ListTileControlAffinity.leading,
                        subtitle: !_acceptedTerms ? const Text("Required to proceed", style: TextStyle(color: Colors.red, fontSize: 12)) : null,
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          onPressed: _dob == null || !_acceptedTerms ? null : _submit,
                          child: const Text("Submit"),
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
      child: Text(letter, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }
}
