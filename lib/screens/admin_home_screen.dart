import 'package:cseduapp/screens/admin/mcq_insert.dart';
import 'package:cseduapp/screens/admin/sentence_insert.dart';
import 'package:cseduapp/screens/admin/user.dart';
import 'package:cseduapp/screens/home_screens/admin_qna.dart';

import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'admin/word_insert.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await StorageService.clearStorage();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.indigo[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Text(
                  'LangMastero Admin',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Divider(color: Colors.indigoAccent),
              _drawerItem(
                context,
                icon: Icons.add_box,
                title: "MCQ Insert",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const McqInsert()),
                  );
                },
              ),
              _drawerItem(
                context,
                icon: Icons.upgrade,
                title: "Sentence Insert",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SentenceInsert()),
                  );
                },
              ),
              _drawerItem(
                context,
                icon: Icons.upload_file,
                title: "Word Upload",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                    MaterialPageRoute(builder: (_) => const WordInsert()),
                  );
                },
              ),
              _drawerItem(
                context,
                icon: Icons.question_answer,
                title: "Manage QnA",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminQnAPage()),
                  );
                },
              ),
              _drawerItem(
                context,
                icon: Icons.video_call,
                title: "Manage User",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UserManage()),
                  );
                },
              ),
              // _drawerItem(
              //   context,
              //   icon: Icons.email,
              //   title: "Email",
              //   onTap: () {
              //     Navigator.pop(context); // Close the drawer
              //     // Placeholder: Navigate to Email screen when available
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text("Email screen not implemented yet")),
              //     );
              //   },
              // ),
              const Spacer(),
              const Divider(color: Colors.indigoAccent),
              _drawerItem(
                context,
                icon: Icons.logout,
                title: "Log Out",
                onTap: () => _logout(context),
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'LangMastero Admin Panel',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'LangMastero Admin Panel',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome to the Admin Dashboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.indigo[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
          const FooterSection(),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color? iconColor,
        Color? textColor,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.indigo,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.indigo[900],
        ),
      ),
      hoverColor: Colors.indigo[50],
      selectedTileColor: Colors.indigo[100],
      onTap: onTap,
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'All rights reserved 2025, Version 25.24.1',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.facebook, color: Colors.blue, size: 24),
            SizedBox(width: 16),
            Icon(Icons.code, color: Colors.black, size: 24),
            SizedBox(width: 16),
            Icon(Icons.business_center, color: Color(0xFF0A66C2), size: 24),
            SizedBox(width: 16),
            Icon(Icons.email, color: Colors.red, size: 24),
          ],
        ),
      ],
    );
  }
}