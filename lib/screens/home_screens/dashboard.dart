import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_profile_provider.dart';
import 'info_card.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfileProvider>(context).userProfile;

    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: userProfile == null
            ? const Center(child: Text("User data not found"))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Student Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.person,
                size: 100,
                color: Colors.blue[800],
              ),
              const SizedBox(height: 20),
              InfoCard(title: "Full Name", value: userProfile.fullName),
              InfoCard(title: "Username", value: userProfile.username),
              InfoCard(title: "Email", value: userProfile.email),
              InfoCard(title: "Phone", value: "${userProfile.countryCode}${userProfile.phoneNumber}"),
              InfoCard(title: "Gender", value: userProfile.gender ?? "Not specified"),
              InfoCard(title: "NID", value: userProfile.nid),
              InfoCard(title: "Date of Birth", value: userProfile.dob.split('T')[0]),
            ],
          ),
        ),
      ),
    );
  }
}
