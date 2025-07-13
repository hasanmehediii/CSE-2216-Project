import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/storage_service.dart';

class AdminQnAPage extends StatefulWidget {
  const AdminQnAPage({super.key});

  @override
  State<AdminQnAPage> createState() => _AdminQnAPageState();
}

class _AdminQnAPageState extends State<AdminQnAPage> {
  final String baseUrl = dotenv.env['BASE_URL']!;
  List<dynamic> qnaList = [];
  bool isLoading = false;
  Map<String, TextEditingController> answerControllers = {};

  @override
  void initState() {
    super.initState();
    fetchQnAs();
  }

  Future<void> fetchQnAs() async {
    setState(() => isLoading = true);
    try {
      final token = await StorageService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/admin/qna/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        answerControllers.clear();
        for (var qna in data) {
          answerControllers[qna['id']] = TextEditingController(text: qna['answer'] ?? '');
        }

        setState(() {
          qnaList = data;
        });
      } else {
        debugPrint('Failed to fetch QnAs: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching QnAs: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> submitAnswer(String id) async {
    final token = await StorageService.getToken();
    final answer = answerControllers[id]?.text.trim() ?? '';

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answer cannot be empty')),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/qna/answer/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'answer': answer}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Answer submitted!')),
        );
        fetchQnAs(); // refresh data
      } else {
        debugPrint('Failed to submit answer: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit answer: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('Error submitting answer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting answer: $e')),
      );
    }
  }

  @override
  void dispose() {
    answerControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin QnA Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : qnaList.isEmpty
            ? const Center(child: Text('No questions found.'))
            : ListView.builder(
          itemCount: qnaList.length,
          itemBuilder: (context, index) {
            final qna = qnaList[index];
            final answerController = answerControllers[qna['id']]!;

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q: ${qna["question"]}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: answerController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Answer',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => submitAnswer(qna['id']),
                      child: const Text('Submit Answer'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
