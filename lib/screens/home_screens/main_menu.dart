import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email ?? "Anonymous";
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _switchAccount() {
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
                child: Text(
                  'LangBuddy',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),

              _buildDrawerItem(Icons.play_arrow, "Start Learning", '/start'),
              _buildDrawerItem(Icons.auto_stories, "Vocabulary", '/vocabulary'),
              _buildDrawerItem(Icons.rule, "Grammar Lessons", '/grammar'),
              _buildDrawerItem(Icons.bar_chart, "Progress", '/progress'),
              _buildDrawerItem(Icons.settings, "Settings", '/settings'),

              const Spacer(),

              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(userEmail ?? 'Not logged in'),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: _logout,
              ),
              ListTile(
                leading: const Icon(Icons.switch_account),
                title: const Text('Switch Account'),
                onTap: _switchAccount,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('LangBuddy'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          'Welcome to LangBuddy Main Menu!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String label, String routeName) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}
