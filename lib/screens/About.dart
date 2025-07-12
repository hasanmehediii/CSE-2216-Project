import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Data for team members
  final List<Map<String, String>> teamMembers = const [
    { 'name': 'Mehedi Hasan', // Placeholder name
      'email': 'mehedi-2022415897@cs.du.ac.bd', // Placeholder email
      'image': 'assets/person1.png', // All images are now .png
    },
    {
      'name': 'Abdullah Evne Masood', // Name from your screenshot
      'email': 'abdullahbmasood@gmail.com', // Email from your screenshot
      'image': 'assets/person2.png', // All images are now .png
    },
    {
      'name': 'Ibna Afra Roza', // Placeholder name
      'email': 'ibnaafra-2022015891@cs.du.ac.bd', // Placeholder email
      'image': 'assets/person3.png', // All images are now .png
    },
    {
      'name': 'Nafisha Akhter', // Placeholder name
      'email': 'nafisha3588@gmail.com', // Placeholder email
      'image': 'assets/person4.png', // All images are now .png
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Floating faded letters in the background (same animation as previous)
              Positioned(top: _animation.value, left: _animation.value, child: _buildFadedLetter('A')),
              Positioned(top: 100 + _animation.value, right: 20 + _animation.value, child: _buildFadedLetter('あ')),
              Positioned(bottom: 100 - _animation.value, left: 20 + _animation.value, child: _buildFadedLetter('ب')),
              Positioned(bottom: 50 + _animation.value, right: 50 - _animation.value, child: _buildFadedLetter('文')),
              Positioned(top: 30 + _animation.value, right: 100 - _animation.value, child: _buildFadedLetter('अ')),
              Positioned(top: 200 - _animation.value, left: 80 + _animation.value, child: _buildFadedLetter('অ')),
              Positioned(bottom: 200 + _animation.value, right: 70 - _animation.value, child: _buildFadedLetter('ñ')),
              Positioned(top: 250 + _animation.value, left: 50 - _animation.value, child: _buildFadedLetter('é')),

              // Main Content in the center
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 80,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "About LangBuddy",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "This app is created by team Quattro, Students, CSE, University of Dhaka. "
                            "It's a language-based app where you can explore a lot of languages easily. "
                            "You will get daily quizzes, brainstorming questions, and so on. "
                            "Stay tuned for more features.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // New Section: Meet Our Team
                      const Text(
                        'Meet Our Team',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Iterate through the team members to create their cards
                      ...teamMembers.map((member) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TeamMemberCard(
                            name: member['name']!,
                            email: member['email']!,
                            imagePath: member['image']!,
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 40),
                      // Back Button to return to the previous page
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text(
                            'Go Back',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
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
      opacity: 0.05,
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

// A custom widget for displaying individual team member information
class TeamMemberCard extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200], // Placeholder background
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: 120, // Ensure fixed width and height for consistency
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading image $imagePath: $error');
                    return const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey,
                    ); // Fallback icon
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}