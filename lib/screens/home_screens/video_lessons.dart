import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoLessonsPage extends StatefulWidget {
  const VideoLessonsPage({super.key});

  @override
  State<VideoLessonsPage> createState() => _VideoLessonsPageState();
}

class _VideoLessonsPageState extends State<VideoLessonsPage> {
  String _selectedLanguage = 'Spanish'; // Default language
  final List<String> _languages = ['Spanish', 'German', 'Arabic', 'Chinese', 'French'];

  late YoutubePlayerController _controller;

  List<Map<String, String>> _videoData = []; // Store video data here
  bool _isLoading = true; // Flag to handle loading state

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchVideos(_selectedLanguage); // Fetch the videos on page load
  }

  // Fetch video data from the backend
  Future<void> fetchVideos(String language) async {
    final url = Uri.parse('http://127.0.0.1:8000/videos/$language');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Fetched data: $data");  // Debug: log the data

        // Ensure the data has the right format and extract the video data
        List<Map<String, String>> videos = [];
        if (data['videos'] != null) {
          videos = List<Map<String, String>>.from(
            (data['videos'] as List).map((video) {
              return {
                'title': video['title'] as String,
                'videoId': video['videoId'] as String,
              };
            }),
          );
        }

        setState(() {
          _videoData = videos; // Set the fetched data to the state
          _isLoading = false;  // Set loading to false after data is fetched
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print('Error fetching videos: $e');
      setState(() {
        _videoData = [];
        _isLoading = false;
      });
    }
  }

  // Play selected video
  void _playVideo(BuildContext context, String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId, // The video ID to start the video
      flags: const YoutubePlayerFlags(
        autoPlay: true, // Auto play the video
        mute: false,     // Do not mute the video by default
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _controller.dispose(); // Properly dispose the controller
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    _isLoading = true; // Set loading to true when fetching new videos
                    fetchVideos(_selectedLanguage); // Fetch new videos on language change
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : _videoData.isEmpty
          ? const Center(child: Text("No videos available"))
          : GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two tiles per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75, // Adjust for thumbnail and title
        ),
        itemCount: _videoData.length,
        itemBuilder: (context, index) {
          final video = _videoData[index];
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
}
