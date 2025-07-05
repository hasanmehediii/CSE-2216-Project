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
  List<int?> userAnswers = []; // Store user's selected option indices
  int currentQuestionIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 300; // 5 minutes
  String selectedLanguage = '';
  final List<String> languages = ['Spanish', 'German', 'Chinese', 'Arabic', 'French'];

  Future<void> startExam(String language) async {
    selectedLanguage = language.toLowerCase();
    final url = Uri.parse("${dotenv.env['BASE_URL']}/mcq/$selectedLanguage");
    print('Requesting URL: $url'); // Debug
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      print('Response status: ${response.statusCode}'); // Debug
      print('Response body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed data: $data'); // Debug
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
          userAnswers = List.filled(questions.length, null); // Initialize user answers
          examStarted = true;
          currentQuestionIndex = 0;
          _remainingSeconds = 300;
        });
        _startTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load MCQs: ${response.statusCode} - ${response.body}')),
        );
        setState(() {
          examStarted = false;
          questions = [];
          userAnswers = [];
        });
      }
    } catch (e) {
      print('Error: $e'); // Debug
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

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              return ListTile(
                title: Text(lang),
                onTap: () {
                  Navigator.of(context).pop();
                  startExam(lang);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Time's Up"),
        content: const Text("Your 5 minutes are over."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                examStarted = false;
                // Keep questions and userAnswers for results
              });
            },
            child: const Text("View Results"),
          ),
        ],
      ),
    );
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
        return Scaffold(
          appBar: AppBar(title: const Text("MCQ Results")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Exam Results",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ...List.generate(questions.length, (index) {
                  final question = questions[index];
                  final userAnswer = userAnswers[index];
                  final correctAnswerIndex = question['answer_index'] as int;
                  final isCorrect = userAnswer == correctAnswerIndex;
                  return Card(
                    elevation: 2,
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
                            final isSelected = userAnswer == i;
                            final isCorrectOption = i == correctAnswerIndex;
                            return Container(
                              color: isSelected
                                  ? (isCorrect ? Colors.green[100] : Colors.red[100])
                                  : (isCorrectOption ? Colors.green[100] : null),
                              child: ListTile(
                                title: Text(question['options'][i].toString()),
                                leading: Radio<int>(
                                  value: i,
                                  groupValue: userAnswer,
                                  onChanged: null, // Disable interaction in results
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 10),
                          Text(
                            "Correct Answer: ${question['options'][correctAnswerIndex]}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
                          ),
                        ],
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
                    child: const Text("Return to Exams"),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Exam selection grid
      return Scaffold(
        appBar: AppBar(title: const Text("MCQ Exams")),
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: _showLanguageSelectionDialog,
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Exam ${index + 1}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    } else if (questions.isEmpty) {
      print('Questions is empty: $questions'); // Debug
      return Scaffold(
        appBar: AppBar(title: const Text("MCQ Exam")),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else if (currentQuestionIndex >= questions.length) {
      setState(() {
        examStarted = false; // Show results
      });
      return const SizedBox(); // Immediately re-render with results
    } else {
      print('Questions loaded: $questions'); // Debug
      final question = questions[currentQuestionIndex];
      if (question['question'] == null || question['options'] == null || question['options'].length < 4) {
        print('Invalid question data: $question'); // Debug
        return Scaffold(
          appBar: AppBar(title: const Text("MCQ Exam")),
          body: Center(child: const Text("Invalid question data")),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text("MCQ Exam"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Question ${currentQuestionIndex + 1} of ${questions.length}",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                question['question'].toString(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...List.generate(question['options'].length, (i) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(question['options'][i].toString()),
                    onTap: () {
                      setState(() {
                        userAnswers[currentQuestionIndex] = i; // Record user answer
                        if (currentQuestionIndex < questions.length - 1) {
                          currentQuestionIndex++;
                        } else {
                          examStarted = false; // Show results
                        }
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      );
    }
  }
}