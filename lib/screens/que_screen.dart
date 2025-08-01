import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/models/que_model.dart';
import '../database/models/que_service.dart';
import '../database/models/que_card.dart';
import 'result_screen.dart';

class ExamCard {
  final String title;
  final bool isUnlocked;
  ExamCard({required this.title, required this.isUnlocked});
}

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool hasStarted = false;
  String selectedLanguage = "English";
  final List<String> languages = [
    "English", "French", "Spanish", "Chinese", "Japanese"
  ];

  int currentIndex = 0;
  int score = 0;
  int currentDay = 0;
  late Timer timer;
  Duration remaining = const Duration(minutes: 30);
  Map<int, int> selectedAnswers = {};
  List<Question> todaysQuestions = [];

  // Define the list of exam cards with 2 unlocked and 8 locked
  List<ExamCard> examCards = List.generate(10, (index) {
    return ExamCard(
      title: "Exam ${index + 1}",
      isUnlocked: index < 2, // The first 2 exams are unlocked
    );
  });

  @override
  void initState() {
    super.initState();
    // Quiz initialization will start only after "Start" is pressed
  }

  Future<void> initQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    currentDay = prefs.getInt('currentDay') ?? 0;

    final questions = await QuestionService.fetchQuestionsForDay(currentDay + 1);
    setState(() {
      todaysQuestions = questions;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (remaining.inSeconds > 0) {
          remaining -= const Duration(seconds: 1);
        } else {
          timer.cancel();
          _submit();
        }
      });
    });
  }

  void _submit() async {
    for (int i = 0; i < todaysQuestions.length; i++) {
      if (selectedAnswers[i] == todaysQuestions[i].answerIndex) {
        score++;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    if (score >= 10 && currentDay < 9) {
      prefs.setInt('currentDay', currentDay + 1);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: score,
          total: todaysQuestions.length,
          day: currentDay,
        ),
      ),
    );
  }

  void _nextQuestion(int? selectedOption) {
    if (selectedOption != null) {
      selectedAnswers[currentIndex] = selectedOption;
      if (currentIndex < todaysQuestions.length - 1) {
        setState(() {
          currentIndex++;
        });
      } else {
        timer.cancel();
        _submit();
      }
    }
  }

  void _startExam(int examIndex) async {
    if (examCards[examIndex].isUnlocked) {
      setState(() {
        hasStarted = true;
      });
      await initQuiz();
    }
  }

  @override
  void dispose() {
    if (hasStarted) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasStarted) {
      // Show the list of exam cards
      return Scaffold(
        appBar: AppBar(
          title: const Text("Select an Exam"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'Choose an exam to start',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1, // Square cards
                  ),
                  itemCount: examCards.length,
                  itemBuilder: (context, index) {
                    final examCard = examCards[index];
                    return GestureDetector(
                      onTap: () => _startExam(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: examCard.isUnlocked ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(examCard.isUnlocked
                                ? 'assets/unlocked_texture.png' // Replace with actual texture asset
                                : 'assets/locked_texture.png'), // Locked texture
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            examCard.title,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (todaysQuestions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final q = todaysQuestions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("MCQ Test - $selectedLanguage"),
        leading: const BackButton(),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "${remaining.inHours.toString().padLeft(2, '0')}:${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}",
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text("Question ${currentIndex + 1} of ${todaysQuestions.length}",
              style: const TextStyle(fontSize: 18)),
          Expanded(
            child: McqCard(
              question: q,
              selectedIndex: selectedAnswers[currentIndex],
              onOptionSelected: _nextQuestion,
            ),
          ),
        ],
      ),
    );
  }
}
