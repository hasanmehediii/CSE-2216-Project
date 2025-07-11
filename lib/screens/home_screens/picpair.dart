import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const LanguageMatchGame());
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
  final List<MatchItem> items = [
    MatchItem(word: 'pomme', imageAsset: 'assets/apple.png'),
    MatchItem(word: 'banane', imageAsset: 'assets/banana.png'),
    MatchItem(word: 'raisin', imageAsset: 'assets/grapes.png'),
    MatchItem(word: 'pastèque', imageAsset: 'assets/watermelon.png'),
    MatchItem(word: 'ananas', imageAsset: 'assets/pineapple.png'),
  ];

  final List<String> words = [
    'pomme', 'banane', 'raisin', 'pastèque', 'ananas', 'chaise'
  ];

  final Map<String, bool> matched = {};

  int secondsLeft = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            Image.asset(item.imageAsset, height: 80),
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
