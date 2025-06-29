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
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            // Background text design with low opacity
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.1,  // Set the opacity to 10%
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "学生信息 | Información del estudiante | Student Information",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent.withOpacity(0.2),  // Subtle text color
                        letterSpacing: 5,  // Optional: for some spacing between characters
                        fontFamily: 'Roboto', // You can use custom font here
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            // The main content (dashboard)
            userProfile == null
                ? const Center(child: Text("User data not found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Student Information",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade300, Colors.blue.shade800],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildInfoCard(
                    title: "Full Name",
                    value: userProfile.fullName,
                    icon: Icons.person_outline,
                  ),
                  _buildInfoCard(
                    title: "Username",
                    value: userProfile.username,
                    icon: Icons.account_box_outlined,
                  ),
                  _buildInfoCard(
                    title: "Email",
                    value: userProfile.email,
                    icon: Icons.email_outlined,
                  ),
                  _buildInfoCard(
                    title: "Phone",
                    value: "${userProfile.countryCode}${userProfile.phoneNumber}",
                    icon: Icons.phone_outlined,
                  ),
                  _buildInfoCard(
                    title: "Gender",
                    value: userProfile.gender ?? "Not specified",
                    icon: Icons.wc_outlined,
                  ),
                  _buildInfoCard(
                    title: "NID",
                    value: userProfile.nid,
                    icon: Icons.card_membership_outlined,
                  ),
                  _buildInfoCard(
                    title: "Date of Birth",
                    value: userProfile.dob.split('T')[0],
                    icon: Icons.calendar_today_outlined,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Action for the button (optional)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom function to build info cards with unique styles
  Widget _buildInfoCard({required String title, required String value, required IconData icon}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shadowColor: Colors.blueAccent.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              child: Icon(
                icon,
                size: 30,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
