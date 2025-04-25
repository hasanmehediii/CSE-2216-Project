import 'package:flutter/material.dart';
import 'WelcomePage.dart';

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

  final validUsers = {
    'user1@example.com': 'password123',
    'test.user@flutter.dev': 'flutter456',
    'hello@world.com': 'mypassword',
  };

  final List<Map<String, String>> _countryCodes = [
    {'country': 'United States', 'code': '+1'},
    {'country': 'Canada', 'code': '+1'},
    {'country': 'United Kingdom', 'code': '+44'},
    {'country': 'Australia', 'code': '+61'},
    {'country': 'India', 'code': '+91'},
    {'country': 'Germany', 'code': '+49'},
    // Add more countries as needed
  ];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (!validUsers.containsKey(_emailController.text) ||
          validUsers[_emailController.text] != _passwordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email/password combination')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(
            fullName: _fullNameController.text,
            email: _emailController.text,
            gender: _gender!,
            dob: _dob!,
            countryCode: _countryCode!,
            phoneNumber: _phoneController.text,
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

                    // Full Name Field
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

                    // Username Field
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

                    // Email Field
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

                    // Phone Number Field with Country Code Dropdown
                    Row(
                      children: [
                        // Country Code Dropdown
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: _countryCode,
                            decoration: const InputDecoration(
                              labelText: "Country Code",
                              border: OutlineInputBorder(),
                            ),
                            items: _countryCodes
                                .map((country) => DropdownMenuItem<String>(
                              value: country['code'],
                              child: Text(country['country']!),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _countryCode = value;
                              });
                            },
                            validator: (value) =>
                            value == null ? "Please select a country code" : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Phone Number Field
                        Expanded(
                          flex: 2,
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

                    // Password Field
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

                    // Gender Dropdown
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
                      value == null ? "Please select a gender" : null,
                    ),
                    const SizedBox(height: 15),

                    // Date of Birth Picker
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

                    // Terms & Conditions Checkbox
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
