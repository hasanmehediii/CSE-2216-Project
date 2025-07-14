import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class SentenceInsert extends StatefulWidget {
  const SentenceInsert({super.key});

  @override
  State<SentenceInsert> createState() => _SentenceInsertState();
}

class _SentenceInsertState extends State<SentenceInsert> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController jsonController = TextEditingController();
  bool isLoading = false;
  String message = '';

  final String baseUrl = '${dotenv.env['BASE_URL']!}/admin';

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> insertSentence() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final Map<String, dynamic> sentenceData = jsonDecode(jsonController.text);

      final response = await http.post(
        Uri.parse('$baseUrl/sentences'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(sentenceData),
      );

      if (response.statusCode == 200) {
        setState(() {
          message = '✅ Sentence inserted successfully!';
        });
      } else {
        setState(() {
          message = '❌ Error: Failed to insert sentence';
        });
      }
    } catch (e) {
      setState(() {
        message = '❌ Invalid JSON format. Please check the data.';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Insert Sentence'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Lottie.asset('assets/gifs/bg_loop.json', fit: BoxFit.cover),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Lottie.asset('assets/gifs/arrow_down.json', height: 100),
                const SizedBox(height: 10),
                SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: jsonController,
                            maxLines: 20,
                            style: const TextStyle(color: Colors.indigo),
                            decoration: const InputDecoration(
                              labelText: 'Paste Sentence JSON here',
                              labelStyle: TextStyle(color: Colors.indigo),
                              hintText: '''{
  "english": "The dog runs in the park",
  "spanish": "El perro corre en el parque",
  "german": "Der Hund läuft im Park",
  "arabic": "الكلب يجري في الحديقة",
  "french": "Le chien court dans le parc",
  "chinese": "狗在公园里跑"
}''',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the JSON data';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                insertSentence();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Insert Sentence',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (isLoading)
                            const CircularProgressIndicator()
                          else if (message.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.lightBlue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    message.contains('Error') ? Icons.error_outline : Icons.check_circle_outline,
                                    color: message.contains('Error') ? Colors.red : Colors.blue,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      message,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
