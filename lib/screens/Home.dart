import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/storage_service.dart';
import '../../providers/user_profile_provider.dart';
import 'home_screens/dashboard.dart';
import 'home_screens/live_quiz.dart';
import 'home_screens/mcq.dart';
import 'home_screens/routine.dart';
import 'home_screens/settings.dart';
import 'home_screens/pro.dart';
import 'home_screens/picpair.dart';
import 'home_screens/video_lessons.dart';
import 'home_screens/sentence_builder.dart';
import 'home_screens/qna.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentAdIndex = 0;
  final PageController _pageController = PageController();
  late Timer _adTimer;

  final Map<String, String> languageDetails = {
    "English": "Learn international communication, business English, and test prep like IELTS/TOEFL.",
    "Spanish": "Master conversational Spanish, grammar, and useful phrases for travel and work.",
    "German": "Build a solid foundation in German speaking, reading, and writing.",
    "Arabic": "Learn Arabic alphabets, speaking skills, and Quranic Arabic.",
    "French": "Improve your French with cultural lessons, phrases, and listening practice.",
  };

  final Map<String, String> courseDetails = {
    "Fall": "Fall courses are long-term, with in-depth grammar and speaking practice, designed for gradual mastery.",
    "Spring": "Spring sessions are ideal for revising or improving your basics with fresh activities and updated content.",
    "One Shot": "One Shot course is a fast-paced, intensive training module covering essential speaking and listening skills in a short time.",
  };

  final List<String> adImages = [
    'assets/ad1.png',
    'assets/ad2.png',
    'assets/ad3.png',
  ];

  final List<Map<String, String>> languages = [
    {"name": "English", "info": "10,000 learners", "rating": "4.5", "students": "10,000"},
    {"name": "Spanish", "info": "20,000 learners", "rating": "4.7", "students": "20,000"},
    {"name": "German", "info": "12,000 learners", "rating": "4.6", "students": "12,000"},
    {"name": "Arabic", "info": "15,000 learners", "rating": "4.8", "students": "15,000"},
    {"name": "French", "info": "18,000 learners", "rating": "4.4", "students": "18,000"},
  ];

  final List<Map<String, String>> courses = [
    {"name": "Fall", "info": "500 learners", "rating": "4.5", "students": "500"},
    {"name": "Spring", "info": "300 learners", "rating": "4.7", "students": "300"},
    {"name": "One Shot", "info": "150 learners", "rating": "4.6", "students": "150"},
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
    final userProvider = Provider.of<UserProfileProvider>(context);
    final userProfile = userProvider.userProfile;

    if (userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userProfile.email == 'admin@gmail.com') {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/admin');
      });
      return const Scaffold();
    }

    final isPremium = userProvider.isPremium;

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('LangMastero', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    _buildDrawerItem(Icons.workspace_premium, "Get Pro", const ProPage()),
                    if (isPremium) _buildDrawerItem(Icons.video_library, "Video Lessons", const VideoLessonsPage()),
                    _buildDrawerItem(Icons.bar_chart, "Progress", const ToDoListPage()),
                    _buildDrawerItem(Icons.menu_book, "Vocabulary", const LiveQuizPage()),
                    _buildDrawerItem(Icons.check_circle_outline, "MCQ Test", const MCQTestPage()),
                    _buildDrawerItem(Icons.image_search, "Flash Cards", const MatchPage()),
                    _buildDrawerItem(Icons.text_snippet, "Sentence Builder", const SentenceBuilderGame()),
                    _buildDrawerItem(Icons.question_answer, "QnA", const QnAPage()),
                    _buildDrawerItem(Icons.settings, "Settings", const SettingsPage()),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(userProfile.fullName),
                onTap: () => _navigateTo(const StudentDashboard()),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () => _logout(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('LangMastero'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            _buildSection("Popular Languages", languages),
            const SizedBox(height: 20),
            _buildSection("Running Courses", courses),
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
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

  Widget _buildSection(String title, List<Map<String, String>> items) {
    final bool isCourseSection = (title == "Running Courses");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildLanguageCard(
                item["name"]!,
                item["info"]!,
                item["rating"]!,
                item["students"]!,
                index,
                isCourseSection,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(String title, String subtitle, String rating, String students, int index, [bool isCourse = false]) {
    final List<Color> cardColors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.red.shade100,
      Colors.purple.shade100
    ];

    return GestureDetector(
      onTap: () {
        final detailText = isCourse
            ? courseDetails[title] ?? "Course details not available."
            : languageDetails[title] ?? "Language details not available.";
        _showCardDetailsDialog(title, subtitle, rating, students, detailText);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColors[index % cardColors.length],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.language, size: 40, color: Colors.indigo),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people, color: Colors.black, size: 18),
                const SizedBox(width: 4),
                Text(students, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetailsDialog(String title, String subtitle, String rating, String students, String detailText) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subtitle),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 5),
                  Text("Rating: $rating"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.people),
                  const SizedBox(width: 5),
                  Text("Students: $students"),
                ],
              ),
              const SizedBox(height: 10),
              Text(detailText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
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
      ),
    );
  }
}