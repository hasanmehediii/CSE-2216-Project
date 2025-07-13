import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SentenceBuilderGame extends StatefulWidget {
  const SentenceBuilderGame({super.key});

  @override
  State<SentenceBuilderGame> createState() => _SentenceBuilderGameState();
}

class _SentenceBuilderGameState extends State<SentenceBuilderGame> {
  String selectedLang = '';
  List<String> correctSentence = [];
  List<String> shuffledWords = [];
  List<String> userSentence = [];
  String resultMessage = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _showLanguagePopup());
  }

  Future<void> _showLanguagePopup() async {
    final lang = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose a Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['english', 'spanish', 'german', 'arabic', 'french', 'chinese']
                .map((lang) => ListTile(
              title: Text(lang[0].toUpperCase() + lang.substring(1)),
              onTap: () => Navigator.of(context).pop(lang),
            ))
                .toList(),
          ),
        );
      },
    );

    if (lang != null) {
      setState(() {
        selectedLang = lang;
      });
      fetchSentence(lang);
    }
  }

  Future<void> fetchSentence(String lang) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final url = Uri.parse('$baseUrl/sentence-builder/random-sentence');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sentence = data[lang];

        if (sentence != null) {
          List<String> words = sentence.trim().split(RegExp(r'\s+'));

          setState(() {
            correctSentence = words;
            shuffledWords = List<String>.from(words)..shuffle();
            userSentence = [];
            resultMessage = '';
          });
        } else {
          setState(() {
            resultMessage = '⚠️ No sentence available in "$lang".';
          });
        }
      } else {
        setState(() {
          resultMessage = '❌ Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = '❌ Failed to connect to backend.\n$e';
      });
    }
  }

  void onWordTap(String word) {
    if (!userSentence.contains(word)) {
      setState(() {
        userSentence.add(word);
      });
    }
  }

  void checkSentence() {
    final formed = userSentence.join(' ').replaceAll(" l' ", " l'");
    final correct = correctSentence.join(' ').replaceAll(" l' ", " l'");
    setState(() {
      resultMessage = (formed == correct)
          ? '✅ Correct!'
          : '❌ Incorrect.\nExpected:\n"$correct"';
    });
  }

  void clearSentence() {
    setState(() {
      userSentence.clear();
      resultMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentence Builder'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 4,
      ),
      body: selectedLang.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '🧩 Arrange the words to form a sentence in:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              selectedLang.toUpperCase(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 24),

            // Shuffled words
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: shuffledWords.map((word) {
                return ElevatedButton(
                  onPressed: () => onWordTap(word),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.black,
                    elevation: 2,
                  ),
                  child: Text(word),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Sentence:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: userSentence
                    .map((word) => Chip(
                  label: Text(word),
                  backgroundColor: Colors.blue.shade50,
                ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: clearSentence,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: checkSentence,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            if (resultMessage.isNotEmpty)
              Text(
                resultMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: resultMessage.startsWith('✅')
                      ? Colors.green
                      : Colors.red.shade700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
