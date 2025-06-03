// Home.dart
import 'package:flutter/material.dart';
import 'home_screens/dashboard.dart';
import 'home_screens/live_quiz.dart';
import 'home_screens/routine.dart';
import '../services/storage_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
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

  // Logout function
  Future<void> _logout(BuildContext context) async {
    await StorageService.clearStorage();
    Provider.of<UserProfileProvider>(context, listen: false).clearUserProfile();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfileProvider>(context).userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Learning'),
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

              SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        userProfile != null
                            ? "Welcome, ${userProfile.fullName}!"
                            : "Welcome, Guest!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (userProfile != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Email: ${userProfile.email}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Username: ${userProfile.username}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      // Add more profile fields as needed
                    ],
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Choose a Language"),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    "English", "Bangla", "Spanish", "Chinese", "Japanese",
                                    "French", "Hindi", "Arabic", "German", "Russian",
                                    "Portuguese", "Italian", "Korean", "Turkish", "Urdu",
                                    "Dutch", "Greek", "Thai", "Swahili", "Persian"
                                  ].map((language) {
                                    return ListTile(
                                      title: Text(language),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        print("Selected language: $language");
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Close"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.language),
                      label: const Text("Select Language"),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          const Text("Your Learning Progress", style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 10),
                          AnimatedContainer(
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOut,
                            child: LinearProgressIndicator(
                              value: 0.6,
                              backgroundColor: Colors.grey[300],
                              color: Colors.green,
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text("60% Completed", style: TextStyle(fontSize: 16, color: Colors.green)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentDashboard())),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.purpleAccent,
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.dashboard, size: 24, color: Colors.white),
                      label: const Text('Student Dashboard', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveQuizPage())),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.orangeAccent,
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.quiz, size: 24, color: Colors.white),
                      label: const Text('Live Quiz', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoutinePage())),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.tealAccent,
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.schedule, size: 24, color: Colors.white),
                      label: const Text('Routine', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.redAccent,
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.logout, size: 24, color: Colors.white),
                      label: const Text('Log Out', style: TextStyle(fontSize: 18, color: Colors.white)),
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

  Widget _buildFadedLetter(String letter) {
    return Opacity(
      opacity: 0.04,
      child: Text(letter, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }
}