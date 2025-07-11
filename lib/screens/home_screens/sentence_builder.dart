import 'package:flutter/material.dart';

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

  final Map<String, List<Map<String, dynamic>>> sentenceData = {
    "french": [
      {"sentence": "Je vais à l'école", "words": ["Je", "vais", "à", "l'", "école"]},
    ],
    "spanish": [
      {"sentence": "Ella come una manzana", "words": ["Ella", "come", "una", "manzana"]},
    ]
  };

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
            children: ['french', 'spanish'].map((lang) {
              return ListTile(
                title: Text(lang[0].toUpperCase() + lang.substring(1)),
                onTap: () => Navigator.of(context).pop(lang),
              );
            }).toList(),
          ),
        );
      },
    );

    if (lang != null) {
      setState(() {
        selectedLang = lang;
        final data = sentenceData[lang]![0];
        correctSentence = data["words"];
        shuffledWords = List<String>.from(correctSentence)..shuffle();
        userSentence = [];
        resultMessage = '';
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
          : '❌ Incorrect.\nExpected: "$correct"';
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
      appBar: AppBar(title: const Text('Sentence Builder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: selectedLang.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text('Arrange the words to form a correct sentence in $selectedLang',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: shuffledWords.map((word) {
                return ElevatedButton(
                  onPressed: () => onWordTap(word),
                  child: Text(word),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),
            const Text('Your Sentence:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: userSentence.map((word) {
                return Chip(label: Text(word));
              }).toList(),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: clearSentence,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: checkSentence,
                  icon: const Icon(Icons.check),
                  label: const Text('Submit'),
                ),
              ],
            ),

            const SizedBox(height: 30),
            Text(resultMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: resultMessage.startsWith('✅')
                        ? Colors.green
                        : Colors.red)),
          ],
        ),
      ),
    );
  }
}
