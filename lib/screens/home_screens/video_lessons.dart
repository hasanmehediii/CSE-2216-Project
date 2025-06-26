// lib/screens/home_screens/video_lessons.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/user_profile_provider.dart';

class VideoLessonsPage extends StatefulWidget {
  const VideoLessonsPage({super.key});

  @override
  State<VideoLessonsPage> createState() => _VideoLessonsPageState();
}

class _VideoLessonsPageState extends State<VideoLessonsPage> {
  String _selectedLanguage = 'Spanish'; // Default language
  final List<String> _languages = ['Spanish', 'German', 'Arabic', 'Chinese', 'French'];

  // Placeholder video data (reusing your provided video IDs)
  final Map<String, List<Map<String, String>>> _videoData = {
    'Spanish': [
      {'title': 'Day 1', 'videoId': 'WHxYhsgobCM'},
      {'title': 'Day 2', 'videoId': '2SIdIAMzHH0'},
      {'title': 'Day 3', 'videoId': 'hsLYD1Jyf3A'},
      {'title': 'Day 4', 'videoId': '8yuiUvi568I'},
      {'title': 'Day 5', 'videoId': '3yO_FR8yiQk'},
      {'title': 'Day 6', 'videoId': 'cjXoSBulHRM'},
      {'title': 'Day 7', 'videoId': 'TqQDNUjDByQ'},
      {'title': 'Day 8', 'videoId': 'nE178FMQ1MQ'},
      {'title': 'Day 9', 'videoId': 'JTrjZNspkWA'},
      {'title': 'Day 10', 'videoId': 'bp9OZoQu3A0'},
    ],
    'German': [
      {'title': 'Day 1', 'videoId': '0p4RCJ8P5ko'},
      {'title': 'Day 2', 'videoId': 'lI4c_R8Wxuc'},
      {'title': 'Day 3', 'videoId': 'xg60VxyK-9I'},
      {'title': 'Day 4', 'videoId': 'sDTCuXvSNFw'},
      {'title': 'Day 5', 'videoId': 'mNX1wpIQ4Uk'},
      {'title': 'Day 6', 'videoId': 'hAkxKMlYUI4'},
      {'title': 'Day 7', 'videoId': 'paDNTjoWExI'},
      {'title': 'Day 8', 'videoId': 'rD8x9ydyEzw'},
      {'title': 'Day 9', 'videoId': 'nf1rzqG3nvA'},
      {'title': 'Day 10', 'videoId': 'r9os9Q6t6Xc'},
    ],
    'Arabic': [
      {'title': 'Day 1', 'videoId': 'dQw4w9WgXcQ'},
      {'title': 'Day 2', 'videoId': '3JcmQONgXhM'},
      {'title': 'Day 3', 'videoId': 'kJQP7kiw5Fk'},
      {'title': 'Day 4', 'videoId': '9bZkp7q19f0'},
      {'title': 'Day 5', 'videoId': 'fJ9rUzIMcZQ'},
      {'title': 'Day 6', 'videoId': 'hT_nvWreIhg'},
      {'title': 'Day 7', 'videoId': '2Vv-BfVoq4g'},
      {'title': 'Day 8', 'videoId': 'YQHsXMglC9A'},
      {'title': 'Day 9', 'videoId': 'tPEE9ZwTmy0'},
      {'title': 'Day 10', 'videoId': 'sCj_bL8mr-A'},
    ],
    'Chinese': [
      {'title': 'Day 1', 'videoId': 'dQw4w9WgXcQ'},
      {'title': 'Day 2', 'videoId': '3JcmQONgXhM'},
      {'title': 'Day 3', 'videoId': 'kJQP7kiw5Fk'},
      {'title': 'Day 4', 'videoId': '9bZkp7q19f0'},
      {'title': 'Day 5', 'videoId': 'fJ9rUzIMcZQ'},
      {'title': 'Day 6', 'videoId': 'hT_nvWreIhg'},
      {'title': 'Day 7', 'videoId': '2Vv-BfVoq4g'},
      {'title': 'Day 8', 'videoId': 'YQHsXMglC9A'},
      {'title': 'Day 9', 'videoId': 'tPEE9ZwTmy0'},
      {'title': 'Day 10', 'videoId': 'sCj_bL8mr-A'},
    ],
    'French': [
      {'title': 'Day 1', 'videoId': 'dQw4w9WgXcQ'},
      {'title': 'Day 2', 'videoId': '3JcmQONgXhM'},
      {'title': 'Day 3', 'videoId': 'kJQP7kiw5Fk'},
      {'title': 'Day 4', 'videoId': '9bZkp7q19f0'},
      {'title': 'Day 5', 'videoId': 'fJ9rUzIMcZQ'},
      {'title': 'Day 6', 'videoId': 'hT_nvWreIhg'},
      {'title': 'Day 7', 'videoId': '2Vv-BfVoq4g'},
      {'title': 'Day 8', 'videoId': 'YQHsXMglC9A'},
      {'title': 'Day 9', 'videoId': 'tPEE9ZwTmy0'},
      {'title': 'Day 10', 'videoId': 'sCj_bL8mr-A'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final isPremium = Provider.of<UserProfileProvider>(context).isPremium;

    if (!isPremium) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
      return const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Lessons"),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              items: _languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language, style: const TextStyle(fontWeight: FontWeight.w600)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                }
              },
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              dropdownColor: Colors.blue[800],
              iconEnabledColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Three tiles per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75, // Adjust for thumbnail and title
        ),
        itemCount: _videoData[_selectedLanguage]!.length,
        itemBuilder: (context, index) {
          final video = _videoData[_selectedLanguage]![index];
          return GestureDetector(
            onTap: () => _playVideo(context, video['videoId']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(-2, -2),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[50]!, Colors.blue[100]!],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Thumbnail
                    Positioned.fill(
                      child: Image.network(
                        'https://img.youtube.com/vi/${video['videoId']}/hqdefault.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.error, color: Colors.red, size: 40),
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Title
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Text(
                        video['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _playVideo(BuildContext context, String videoId) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = YoutubePlayerController(
          initialVideoId: videoId,
          params: const YoutubePlayerParams(
            autoPlay: true,
            mute: false,
            showControls: true,
            showFullscreenButton: true,
          ),
        );

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: YoutubePlayerIFrame(
              controller: controller,
              aspectRatio: 16 / 9,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.close();
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // Fallback to open YouTube in browser
  Future<void> _openYouTube(String videoId) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open YouTube")),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}