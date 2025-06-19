import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final int day;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    bool passed = score >= 10;
    bool isFinalDay = day == 9 && passed;

    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You scored $score out of $total", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            isFinalDay
                ? const Text("🎉 You've completed the Beginner Level!", style: TextStyle(fontSize: 18))
                : passed
                ? Column(
              children: [
                Image.asset('assets/happy.png', height: 120),
                const Text("Well done! See you tomorrow!", style: TextStyle(fontSize: 18)),
              ],
            )
                : Column(
              children: [
                Image.asset('assets/sad.png', height: 120),
                const Text("Oops! You need at least 10 to pass.", style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
