import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../database/models/user_model.dart';
import 'info_card.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  AppUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          _user = AppUser.fromMap(doc.data()!);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _user == null
            ? const Center(child: Text("User data not found"))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Student Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              InfoCard(title: "Full Name", value: _user!.fullName),
              InfoCard(title: "Username", value: _user!.username),
              InfoCard(title: "Email", value: _user!.email),
              InfoCard(title: "Phone", value: "${_user!.countryCode}${_user!.phoneNumber}"),
              InfoCard(title: "Gender", value: _user!.gender),
              InfoCard(title: "NID", value: _user!.nid),
              InfoCard(title: "Date of Birth", value: _user!.dob.split('T')[0]),
            ],
          ),
        ),
      ),
    );
  }
}
