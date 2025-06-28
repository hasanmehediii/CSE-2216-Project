import 'dart:html' as html; // Import html for Web Speech API
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For JSON decoding
import 'package:flutter_tts/flutter_tts.dart';  // For Text-to-Speech

class LiveQuizPage extends StatefulWidget {
  const LiveQuizPage({super.key});

  @override
  State<LiveQuizPage> createState() => _LiveQuizPageState();
}

class _LiveQuizPageState extends State<LiveQuizPage> {
  int _currentIndex = 0;
  String _selectedLanguage = 'spanish';  // Default language
  List<Map<String, dynamic>> _words = [];
  FlutterTts _flutterTts = FlutterTts();  // Initialize Text-to-Speech instance

  // List of available languages
  List<String> _languages = ['spanish', 'german', 'arabic', 'chinese', 'french'];

  // Fetch data from FastAPI
  Future<void> _fetchWords() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/words'));  // FastAPI endpoint

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _words = data.map((word) {
          return {
            'wordText': word['english_word'],
            'imageUrl': word['image_link'],
            'translations': word['translations'],
            'englishMeaning': word['englishMeaning'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load words');
    }
  }

  // Function to move to the next word
  void _nextWord() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _words.length;
    });
  }

  // Function to move to the previous word
  void _previousWord() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _words.length) % _words.length;
    });
  }

  // Function to pronounce a word using TTS
  Future<void> _speak(String word) async {
    if (kIsWeb) {
      // Web-specific implementation using the Web Speech API
      final speech = html.window.speechSynthesis;
      final utterance = html.SpeechSynthesisUtterance(word);

      // Optional: Configure the speech parameters (rate, pitch, etc.)
      utterance.rate = 0.8;  // Speed of speech (0.1 to 10)
      utterance.pitch = 1.0; // Pitch of the voice (0 to 2)
      utterance.volume = 1.0; // Volume (0 to 1)

      // Speak the word
      speech?.speak(utterance);
    } else {
      // Native mobile platforms (Android/iOS)
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(word); // Speak the word on mobile platforms
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWords();  // Fetch words when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Word Display'),
          backgroundColor: Colors.teal,
          leading: BackButton(), // Add back button
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentWord = _words[_currentIndex];

    // Get the translation for the selected language
    final selectedWordTranslation = currentWord['translations'][_selectedLanguage] ?? "Translation not available";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Display'),
        backgroundColor: Colors.teal,
        leading: BackButton(), // Add back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // First row with the image
                if (currentWord['imageUrl'] != null && currentWord['imageUrl'] is String)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          currentWord['imageUrl'] ?? "",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                else
                  Container(),

                // Language selection dropdown
                DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                  items: _languages.map<DropdownMenuItem<String>>((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language.toUpperCase()),
                    );
                  }).toList(),
                ),

                // Second row with two cards horizontally
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              children: [
                                Text(
                                  _selectedLanguage.toUpperCase(), // Display selected language
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  selectedWordTranslation, // Display translation of the selected language
                                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),  // Spacing between cards
                      Expanded(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              children: [
                                const Text(
                                  'English Meaning',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  currentWord['englishMeaning'] ?? "Unknown",  // Fallback if null
                                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Microphone Icons below each card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.teal),
                      onPressed: () {
                        _speak(selectedWordTranslation); // Speak translation
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.teal),
                      onPressed: () {
                        _speak(currentWord['wordText']); // Speak English word
                      },
                    ),
                  ],
                ),

                // Navigation buttons (Previous and Next)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _previousWord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous', style: TextStyle(fontSize: 18)),
                    ),
                    ElevatedButton.icon(
                      onPressed: _nextWord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
