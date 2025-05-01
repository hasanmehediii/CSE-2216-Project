import 'package:flutter/material.dart';

import 'info_card.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final String name = "Nafisha Tuli";
    final int age = 20;
    final String dob = "March 5, 2005";
    final String year = "2nd Year";
    final String studentId = "CSE-2216";
    final String session = "2022-23";

    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Student Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            InfoCard(title: "Name", value: name),
            InfoCard(title: "Age", value: "$age"),
            InfoCard(title: "Date of Birth", value: dob),
            InfoCard(title: "Current Year", value: year),
            InfoCard(title: "Student ID", value: studentId),
            InfoCard(title: "Session", value: session),
          ],
        ),
      ),
    );
  }
}