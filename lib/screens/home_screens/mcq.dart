import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MCQTestPage extends StatefulWidget {
  const MCQTestPage({super.key});

  @override
  State<MCQTestPage> createState() => _MCQTestPageState();
}

class _MCQTestPageState extends State<MCQTestPage> {
  bool examStarted = false;
  List<dynamic> questions = [];
  List<int?> userAnswers = [];
  int _remainingSeconds = 300;
  Timer? _timer;
  String selectedLanguage = '';
  final List<String> languages = ['Spanish', 'German', 'Chinese', 'Arabic', 'French'];
  final List<Color> cardColors = [
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.purple.shade200,
  ];

  Future<void> startExam(String language, int examIndex) async {
    selectedLanguage = language.toLowerCase();
    final url = Uri.parse("${dotenv.env['BASE_URL']}/mcq/$selectedLanguage?skip=${examIndex * 10}");
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['questions'] == null || data['questions'].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No questions available for $language')),
          );
          setState(() {
            examStarted = false;
            questions = [];
            userAnswers = [];
          });
          return;
        }
        setState(() {
          questions = data['questions'];
          userAnswers = List.filled(questions.length, null);
          examStarted = true;
          _remainingSeconds = 300;
        });
        _startTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load MCQs: ${response.statusCode}')),
        );
        setState(() {
          examStarted = false;
          questions = [];
          userAnswers = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading MCQs: $e')),
      );
      setState(() {
        examStarted = false;
        questions = [];
        userAnswers = [];
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        _showTimeUpDialog();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _showLanguageSelectionDialog(int examIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/good.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 10),
              ...languages.map((lang) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      startExam(lang, examIndex);
                    },
                    child: Text(
                      lang,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Time's Up", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Your 5 minutes are over."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                examStarted = false;
              });
            },
            child: const Text("View Results", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showEndExamDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("End Exam", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to submit and end the exam?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                examStarted = false;
                _timer?.cancel();
              });
            },
            child: const Text("Submit", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i]['answer_index']) {
        score++;
      }
    }
    return score;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!examStarted) {
      if (questions.isNotEmpty && userAnswers.isNotEmpty) {
        // Results screen
        final score = _calculateScore();
        return Scaffold(
          appBar: AppBar(
            title: const Text("MCQ Results"),
            backgroundColor: Colors.blue.shade700,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Exam Results - Score: $score/${questions.length}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  score <= 3
                      ? 'assets/reactions/sad.png'
                      : (score <= 7 ? 'assets/reactions/mid.png' : 'assets/reactions/happy.png'),
                  height: 120,
                ),
                const SizedBox(height: 20),
                ...List.generate(questions.length, (index) {
                  final question = questions[index];
                  final userAnswer = userAnswers[index];
                  final correctAnswerIndex = question['answer_index'] as int;
                  final isCorrect = userAnswer == correctAnswerIndex;
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Card(
                      elevation: 4,
                      color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Question ${index + 1}: ${question['question']}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            ...List.generate(question['options'].length, (i) {
                              final isSelected = userAnswer == i;
                              final isCorrectOption = i == correctAnswerIndex;
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isCorrect ? Colors.green.shade300 : Colors.red.shade300)
                                      : (isCorrectOption ? Colors.green.shade200 : Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: ListTile(
                                  title: Text(question['options'][i].toString()),
                                  leading: Radio<int>(
                                    value: i,
                                    groupValue: userAnswer,
                                    onChanged: null,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 10),
                            Text(
                              "Correct Answer: ${question['options'][correctAnswerIndex]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        examStarted = false;
                        questions = [];
                        userAnswers = [];
                        _timer?.cancel();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      "Return to Exams",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }
      // Exam selection grid
      return Scaffold(
        appBar: AppBar(
          title: const Text("MCQ Exams"),
          backgroundColor: Colors.blue.shade700,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: List.generate(15, (index) {
            return GestureDetector(
              onTap: () => _showLanguageSelectionDialog(index),
              child: AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Card(
                  elevation: 6,
                  color: cardColors[index % cardColors.length],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      "Exam ${index + 1}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    } else if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("MCQ Exam"), backgroundColor: Colors.blue.shade700),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("MCQ Exam"),
          backgroundColor: Colors.blue.shade700,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(questions.length, (index) {
                final question = questions[index];
                // Simplified validation to ensure all questions are shown
                if (question['question'] == null || question['options'] == null) {
                  return const SizedBox();
                }
                return AnimatedSlide(
                  offset: Offset(0, index * 0.1),
                  duration: const Duration(milliseconds: 500),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Question ${index + 1}: ${question['question']}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(question['options'].length, (i) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  userAnswers[index] = i;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: userAnswers[index] == i ? Colors.blue.shade100 : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: ListTile(
                                  title: Text(question['options'][i].toString()),
                                  leading: Radio<int>(
                                    value: i,
                                    groupValue: userAnswers[index],
                                    onChanged: (value) {
                                      setState(() {
                                        userAnswers[index] = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 400),
              Center(
                child: ElevatedButton(
                  onPressed: _showEndExamDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Submit Exam",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }
  }
}