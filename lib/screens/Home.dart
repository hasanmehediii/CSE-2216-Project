import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../providers/user_profile_provider.dart';
import '../screens/que_screen.dart';
import 'home_screens/dashboard.dart';
import 'home_screens/live_quiz.dart';
import 'home_screens/routine.dart';
import 'home_screens/writing.dart';
import 'home_screens/settings.dart';
import 'home_screens/pro.dart';
import 'home_screens/video_lessons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentAdIndex = 0;
  final PageController _pageController = PageController();
  late Timer _adTimer;

  final List<String> adImages = [
    'assets/ad1.jpg',
    'assets/ad2.jpg',
    'assets/ad3.jpg',
  ];

  final List<Map<String, String>> languages = [
    {"name": "English", "info": "10,000 learners", "rating": "4.5", "students": "10,000"},
    {"name": "Spanish", "info": "20,000 learners", "rating": "4.7", "students": "20,000"},
    {"name": "German", "info": "12,000 learners", "rating": "4.6", "students": "12,000"},
    {"name": "Arabic", "info": "15,000 learners", "rating": "4.8", "students": "15,000"},
    {"name": "French", "info": "18,000 learners", "rating": "4.4", "students": "18,000"},
  ];

  final List<Map<String, String>> courses = [
    {"name": "Summer Course", "info": "500 learners", "rating": "4.5", "students": "500"},
    {"name": "Spring Course", "info": "300 learners", "rating": "4.7", "students": "300"},
    {"name": "One Shot Course", "info": "150 learners", "rating": "4.6", "students": "150"},
  ];

  @override
  void initState() {
    super.initState();
    _adTimer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      if (_pageController.hasClients) {
        _currentAdIndex = (_currentAdIndex + 1) % adImages.length;
        _pageController.animateToPage(
          _currentAdIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _adTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateTo(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _logout(BuildContext context) async {
    await StorageService.clearStorage();
    Provider.of<UserProfileProvider>(context, listen: false).clearUserProfile();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfileProvider>(context).userProfile;
    final isPremium = Provider.of<UserProfileProvider>(context).isPremium;

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('LangBuddy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              _buildDrawerItem(Icons.workspace_premium, "Get Pro", const ProPage()),
              if (isPremium) _buildDrawerItem(Icons.video_library, "Video Lessons", const VideoLessonsPage()),
              _buildDrawerItem(Icons.bar_chart, "Progress", const RoutinePage()),
              _buildDrawerItem(Icons.menu_book, "Vocabulary", const LiveQuizPage()),
              _buildDrawerItem(Icons.check_circle_outline, "MCQ Test", const QuestionScreen()),
              _buildDrawerItem(Icons.edit_note, "Written Test", const WritingTestPage()),
              _buildDrawerItem(Icons.settings, "Settings", const SettingsPage()),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(userProfile?.fullName ?? 'Guest'),
                onTap: () => _navigateTo(const StudentDashboard()),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () => _logout(context),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Carousel for Ads
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                itemCount: adImages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(adImages[index], fit: BoxFit.cover),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Popular Languages", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            // Language Cards Section (2 columns)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 30, // Increased space between the cards
                  mainAxisSpacing: 30, // Increased space between the cards
                  childAspectRatio: 0.75, // Aspect ratio to ensure square cards
                ),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return _buildLanguageCard(lang["name"]!, lang["info"]!, lang["rating"]!, lang["students"]!, index);
                },
              ),
            ),
            const SizedBox(height: 20),
            // Running Courses Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Running Courses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            // Course Cards Section (same as language cards)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 30, // Increased space between the cards
                  mainAxisSpacing: 30, // Increased space between the cards
                  childAspectRatio: 0.6, // Aspect ratio to ensure square cards
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return _buildLanguageCard(course["name"]!, course["info"]!, course["rating"]!, course["students"]!, index);
                },
              ),
            ),
            const SizedBox(height: 20),
            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  const Text(
                    'All rights reserved 2025, Version 25.24.1',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.facebook, color: Colors.blue, size: 24),
                      SizedBox(width: 16),
                      Icon(Icons.code, color: Colors.black, size: 24), // GitHub
                      SizedBox(width: 16),
                      Icon(Icons.business_center, color: Color(0xFF0A66C2), size: 24), // LinkedIn
                      SizedBox(width: 16),
                      Icon(Icons.email, color: Colors.red, size: 24),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each drawer item
  ListTile _buildDrawerItem(IconData icon, String label, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () => _navigateTo(page),
    );
  }

  // Function to build each language or course card
  Widget _buildLanguageCard(String title, String subtitle, String rating, String students, int index) {
    final List<Color> cardColors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.red.shade100,
      Colors.purple.shade100
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardColors[index % cardColors.length], // Alternate colors for each card
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12, // Slightly more pronounced shadow
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.language,
              color: Colors.blue.shade700,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 18),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people, color: Colors.black, size: 18),
                const SizedBox(width: 4),
                Text(
                  students,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
