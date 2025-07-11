import 'package:flutter/material.dart';

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
    'pomme', 'banane', 'raisin', 'pastèque', 'ananas', 'chaise' // distractor
  ];

  final Map<String, bool> matched = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match the Words to Pictures')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Images Column
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
            // Words Column
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
