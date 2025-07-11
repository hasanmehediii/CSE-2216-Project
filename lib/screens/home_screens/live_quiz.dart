import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

class LiveQuizPage extends StatefulWidget {
  const LiveQuizPage({super.key});

  @override
  State<LiveQuizPage> createState() => _LiveQuizPageState();
}

class _LiveQuizPageState extends State<LiveQuizPage> {
  int _currentIndex = 0;
  String _selectedLanguage = 'spanish'; // Default language
  List<Map<String, dynamic>> _words = [];
  bool _showPopup = true; // Flag to control popup visibility
  final FlutterTts _flutterTts = FlutterTts(); // Initialize flutter_tts

  // List of available languages
  List<String> _languages = ['spanish', 'german', 'arabic', 'chinese', 'french'];

  // Fetch data from FastAPI
  Future<void> _fetchWords() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://192.168.3.107:8000';
    final response = await http.get(Uri.parse('$baseUrl/words'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _words = data.map((word) {
          String englishWord = _sanitizeString(word['english_word']);
          String imageLink = _sanitizeString(word['image_link']);
          Map<String, dynamic> translations = word['translations'] is Map
              ? Map<String, dynamic>.from(word['translations'])
              : {};
          String englishMeaning = _sanitizeString(word['englishMeaning']);

          print('Fetched word: english_word="$englishWord", translation for $_selectedLanguage="${translations[_selectedLanguage]}", meaning="$englishMeaning"');

          return {
            'wordText': englishWord,
            'imageUrl': imageLink,
            'translations': translations,
            'englishMeaning': englishMeaning,
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load words');
    }
  }

  // ✅ Updated: Helper function to sanitize strings
  String _sanitizeString(dynamic input) {
    if (input == null) return '';
    if (input is Map) {
      return input['text']?.toString().trim() ?? '';
    }
    return input.toString().trim();
  }

  void _nextWord() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _words.length;
    });
  }

  void _previousWord() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _words.length) % _words.length;
    });
  }

  Future<void> _speak(String word, {String? language}) async {
    String cleanWord = _sanitizeString(word);
    if (cleanWord.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid word to pronounce')),
      );
      return;
    }

    print('Speaking word: "$cleanWord" in language: $language');

    String targetLanguage = language ?? 'english';
    String ttsLanguageCode = _getTtsLanguageCode(targetLanguage);

    bool isAvailable = await _flutterTts.isLanguageAvailable(ttsLanguageCode);
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TTS language ${targetLanguage.toUpperCase()} is not available on this device.')),
      );
      return;
    }

    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setLanguage(ttsLanguageCode);

    await _flutterTts.speak(cleanWord);
  }

  String _getTtsLanguageCode(String language) {
    switch (language.toLowerCase()) {
      case 'spanish':
        return 'es-ES';
      case 'german':
        return 'de-DE';
      case 'arabic':
        return 'ar-SA';
      case 'chinese':
        return 'zh-CN';
      case 'french':
        return 'fr-FR';
      default:
        return 'en-US';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWords();
    _initTts();

    Future.delayed(Duration.zero, () {
      if (_showPopup) {
        _showWelcomeDialog();
      }
    });
  }

  Future<void> _initTts() async {
    await _flutterTts.setSharedInstance(true);
    try {
      await _flutterTts.setEngine('com.google.android.tts');
      print('TTS engine set to Google TTS');
    } catch (e) {
      print('Failed to set TTS engine: $e');
    }
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Let's Start Learning Words!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/good.png', height: 100, width: 100),
              const SizedBox(height: 10),
              const Text("Let's start learning words with images!"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _showPopup = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Start Learning"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Word Display'),
          backgroundColor: Colors.teal,
          leading: const BackButton(),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentWord = _words[_currentIndex];
    final selectedWordTranslation = _sanitizeString(currentWord['translations'][_selectedLanguage]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Display'),
        backgroundColor: Colors.teal,
        leading: const BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (currentWord['imageUrl'] != null && currentWord['imageUrl'] is String)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: currentWord['imageUrl'] ?? "",
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                else
                  Container(),

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
                                  _selectedLanguage.toUpperCase(),
                                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  selectedWordTranslation,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              children: [
                                const Text(
                                  'English',
                                  style: TextStyle(fontSize: 16, color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  currentWord['englishMeaning'] ?? "Unknown",
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
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

                // ✅ Pronunciation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.teal),
                      onPressed: () {
                        _speak(selectedWordTranslation, language: _selectedLanguage);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.teal),
                      onPressed: () {
                        _speak(currentWord['wordText'], language: 'english');
                      },
                    ),
                  ],
                ),

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
