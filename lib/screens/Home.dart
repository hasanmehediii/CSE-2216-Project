import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screens/dashboard.dart';
import 'home_screens/live_quiz.dart';
import 'home_screens/writing.dart';
import 'home_screens/mcq.dart';
import 'home_screens/settings.dart';
import 'home_screens/pro.dart';
import 'home_screens/routine.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String? fullName;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    fullName = user?.displayName ?? user?.email ?? widget.userName;

    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _navigateTo(Widget page) {
    Navigator.pop(context); // Close drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
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
              _buildDrawerItem(Icons.workspace_premium, "Get Pro", const ProPage()),
              _buildDrawerItem(Icons.bar_chart, "Progress", const RoutinePage()),
              _buildDrawerItem(Icons.menu_book, "Vocabulary", const LiveQuizPage()),
              _buildDrawerItem(Icons.check_circle_outline, "MCQ Test", const MCQTestPage()),
              _buildDrawerItem(Icons.edit_note, "Written Test", const WritingTestPage()),
              _buildDrawerItem(Icons.settings, "Settings", const SettingsPage()),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(fullName ?? 'Not logged in'),
                onTap: () => _navigateTo(const StudentDashboard()),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: _logout,
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
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(top: _animation.value, left: _animation.value, child: _buildFadedLetter('A')),
              Positioned(top: 100 + _animation.value, right: 20 + _animation.value, child: _buildFadedLetter('あ')),
              Positioned(bottom: 100 - _animation.value, left: 20 + _animation.value, child: _buildFadedLetter('ب')),
              Positioned(bottom: 50 + _animation.value, right: 50 - _animation.value, child: _buildFadedLetter('文')),
              Positioned(top: 30 + _animation.value, right: 100 - _animation.value, child: _buildFadedLetter('अ')),
              Positioned(top: 200 - _animation.value, left: 80 + _animation.value, child: _buildFadedLetter('অ')),
              Positioned(bottom: 200 + _animation.value, right: 70 - _animation.value, child: _buildFadedLetter('ñ')),
              Positioned(top: 250 + _animation.value, left: 50 - _animation.value, child: _buildFadedLetter('é')),

              // Foreground content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.language, size: 80, color: Colors.blueAccent),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to LangBuddy!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hello, ${widget.userName}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String label, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () => _navigateTo(page),
    );
  }

  Widget _buildFadedLetter(String letter) {
    return Opacity(
      opacity: 0.05,
      child: Text(
        letter,
        style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
