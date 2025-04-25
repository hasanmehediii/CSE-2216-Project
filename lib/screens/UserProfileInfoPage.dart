import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final String fullName;
  final String email;
  final String gender;
  final DateTime dob;
  final String countryCode;
  final String phoneNumber;

  const WelcomePage({
    super.key,
    required this.fullName,
    required this.email,
    required this.gender,
    required this.dob,
    required this.countryCode,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F6),
      appBar: AppBar(
        title: const Text("Welcome"),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, $fullName!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  infoTile("Email", email),
                  const SizedBox(height: 10),
                  infoTile("Gender", gender),
                  const SizedBox(height: 10),
                  infoTile("Date of Birth", dob.toLocal().toString().split(' ')[0]),
                  const SizedBox(height: 10),
                  infoTile("Country Code", countryCode),
                  const SizedBox(height: 10),
                  infoTile("Phone Number", phoneNumber),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget infoTile(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
