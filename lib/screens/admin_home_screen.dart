import 'package:flutter/material.dart';
import '../services/storage_service.dart';

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
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('LangMastero Admin',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              _drawerItem(Icons.add_box, "MCQ Insert"),
              _drawerItem(Icons.upgrade, "Upgrade"),
              _drawerItem(Icons.upload_file, "File Upload"),
              _drawerItem(Icons.video_call, "Join Live Class"),
              _drawerItem(Icons.email, "Email"),
              const Spacer(),
              const Divider(),
              _drawerItem(Icons.logout, "Log Out", onTap: () => _logout(context)),
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
        children: const [
          Center(
            child: Column(
              children: [
                Text(
                  'LangMastero Admin Panel',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Welcome to the Admin Dashboard',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          SizedBox(height: 80),
          FooterSection(),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap ?? () {}, // Will link later
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'All rights reserved 2025, Version 25.24.1',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
