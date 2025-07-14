import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/storage_service.dart';


class QnAPage extends StatefulWidget {
  const QnAPage({super.key});

  @override
  State<QnAPage> createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {
  final TextEditingController questionController = TextEditingController();
  final String baseUrl = dotenv.env['BASE_URL']!;
  List<dynamic> qnaList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchQnAs();
  }

  Future<void> fetchQnAs() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/qna/all'));

      if (response.statusCode == 200) {
        setState(() {
          qnaList = jsonDecode(response.body);
        });
      } else {
        debugPrint('Failed to fetch QnAs');
      }
    } catch (e) {
      debugPrint('Error fetching QnAs: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> submitQuestion() async {
    final question = questionController.text.trim();
    if (question.isEmpty) return;

    try {
      final token = await StorageService.getToken();  // Get token

      final response = await http.post(
        Uri.parse('$baseUrl/qna/ask'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Add Authorization header
        },
        body: jsonEncode({'question': question}),
      );

      if (response.statusCode == 200) {
        questionController.clear();
        fetchQnAs(); // refresh after asking
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question submitted!')),
        );
      } else {
        debugPrint('Failed to submit question: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit question: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('Error submitting question: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting question: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QnA - Ask & Learn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Question input
            TextField(
              controller: questionController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Ask a question...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: submitQuestion,
              icon: const Icon(Icons.send),
              label: const Text('Submit Question'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text('Previously Answered Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : qnaList.isEmpty
                  ? const Center(child: Text('No questions found.'))
                  : ListView.builder(
                itemCount: qnaList.length,
                itemBuilder: (context, index) {
                  final qna = qnaList[index];
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
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text('A: ${qna["answer"] ?? "Not answered yet"}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
