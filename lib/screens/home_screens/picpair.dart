import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const LanguageMatchGame());
}


class PictureMatchWord {
  final String word;
  final String imageLink;

  PictureMatchWord({required this.word, required this.imageLink});

  factory PictureMatchWord.fromJson(Map<String, dynamic> json) {
    return PictureMatchWord(
      word: json['word'],
      imageLink: json['image_link'],
    );
  }
}

Future<List<PictureMatchWord>> fetchPictureMatchWords(String lang) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.get(Uri.parse('$baseUrl/picture-match?lang=$lang'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((e) => PictureMatchWord.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load words');
  }
}

class LanguageMatchGame extends StatelessWidget {
  const LanguageMatchGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picture Match Game',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MatchPage(),
    );
  }
}

class MatchItem {
  final String word;
  final String imageAsset;
  const MatchItem({required this.word, required this.imageAsset});
}

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  List<PictureMatchWord> items = [];
  bool isLoading = true;


  List<String> words = [];
  final Map<String, bool> matched = {};
  int secondsLeft = 30;
  Timer? timer;

  @override
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final selectedLang = await _showLanguagePopup(context);
      if (selectedLang == null) return;

      fetchPictureMatchWords(selectedLang).then((fetchedItems) {
        setState(() {
          items = fetchedItems;
          words = fetchedItems.map((e) => e.word).toList();
          //words.add('distractor'); // optional
          words.shuffle();
          isLoading = false;
        });
      });

      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          if (secondsLeft > 0) {
            secondsLeft--;
          } else {
            timer?.cancel();
            int score = matched.values.where((v) => v == true).length;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ScorePage(score: score, total: items.length),
              ),
            );
          }
        });
      });
    });
  }


  Future<String?> _showLanguagePopup(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final List<String> languages = ['french', 'spanish', 'german', 'arabic', 'chinese'];
        return AlertDialog(
          title: const Text("Choose a Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              return ListTile(
                title: Text(lang[0].toUpperCase() + lang.substring(1)),
                onTap: () => Navigator.of(context).pop(lang),
              );
            }).toList(),
          ),
        );
      },
    );
  }





  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match the Words to Pictures'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Time: $secondsLeft s',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: items.map((item) {
                  return DragTarget<String>(
                    onWillAccept: (data) => true,
                    onAccept: (receivedWord) {
                      setState(() {
                        matched[item.word] = (item.word == receivedWord);
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      bool isMatched = matched[item.word] == true;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isMatched ? Colors.green : Colors.black,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image.network(item.imageLink, height: 80),
                            if (isMatched)
                              Text(item.word, style: const TextStyle(fontSize: 18, color: Colors.green))
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),

              ),
            ),
            const VerticalDivider(thickness: 2),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: words.map((word) {
                  return Draggable<String>(
                    data: word,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Text(word, style: const TextStyle(fontSize: 18, color: Colors.blue)),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.4,
                      child: Text(word, style: const TextStyle(fontSize: 18)),
                    ),
                    child: Text(word, style: const TextStyle(fontSize: 18)),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ScorePage extends StatelessWidget {
  final int score;
  final int total;

  const ScorePage({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Score')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score: $score / $total', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            )
          ],
        ),
      ),
    );
  }
}
