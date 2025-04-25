import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _countryCode;
  String? _gender;
  DateTime? _dob;
  bool _acceptedTerms = false;

  final List<Map<String, String>> _countryCodes = [
    {'country': 'United States', 'code': '+1'},
    {'country': 'Canada', 'code': '+1'},
    {'country': 'United Kingdom', 'code': '+44'},
    {'country': 'Australia', 'code': '+61'},
    {'country': 'India', 'code': '+91'},
    {'country': 'Germany', 'code': '+49'},
  ];

  String getFlagEmoji(String code) {
    switch (code) {
      case '+1':
        return '🇺🇸';
      case '+44':
        return '🇬🇧';
      case '+61':
        return '🇦🇺';
      case '+91':
        return '🇮🇳';
      case '+49':
        return '🇩🇪';
      default:
        return '';
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('fullName', _fullNameController.text);
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('phoneNumber', _phoneController.text);
      await prefs.setString('countryCode', _countryCode!);
      await prefs.setString('gender', _gender!);
      await prefs.setString('dob', _dob!.toIso8601String());
      await prefs.setString('password', _passwordController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userName: _usernameController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F6),
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Full Name
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.trim().length < 3
                          ? "Enter at least 3 characters"
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // Username
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? "Username is required"
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || !value.contains('@') || !value.contains('.')
                          ? "Enter a valid email"
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // Country Code + Phone
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: _countryCode,
                            decoration: const InputDecoration(
                              labelText: "Code",
                              border: OutlineInputBorder(),
                            ),
                            items: _countryCodes.map((country) {
                              final code = country['code']!;
                              return DropdownMenuItem<String>(
                                value: code,
                                child: Text('$code ${getFlagEmoji(code)}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _countryCode = value;
                              });
                            },
                            validator: (value) =>
                            value == null ? "Select code" : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? "Phone number is required"
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.length < 6
                          ? "Password must be at least 6 characters"
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // Gender
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                      ),
                      items: ['Male', 'Female', 'Other']
                          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (value) => setState(() => _gender = value),
                      validator: (value) =>
                      value == null ? "Select gender" : null,
                    ),
                    const SizedBox(height: 15),

                    // DOB
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_dob == null
                          ? "Select Date of Birth"
                          : "Date of Birth: ${_dob!.toLocal().toString().split(' ')[0]}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _dob = picked);
                        }
                      },
                    ),
                    if (_dob == null)
                      const Padding(
                        padding: EdgeInsets.only(left: 8, top: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Date of Birth is required",
                              style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    const SizedBox(height: 10),

                    // T&C Checkbox
                    CheckboxListTile(
                      value: _acceptedTerms,
                      onChanged: (value) =>
                          setState(() => _acceptedTerms = value ?? false),
                      title: const Text("I accept Terms & Conditions"),
                      controlAffinity: ListTileControlAffinity.leading,
                      subtitle: !_acceptedTerms
                          ? const Text("Required to proceed",
                          style: TextStyle(color: Colors.red, fontSize: 12))
                          : null,
                    ),

                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
          ),
        ),
      ),
    );
  }
}
