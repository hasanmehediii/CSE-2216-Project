import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class WordInsert extends StatefulWidget {
  const WordInsert({super.key});

  @override
  _WordInsertState createState() => _WordInsertState();
}

class _WordInsertState extends State<WordInsert> with SingleTickerProviderStateMixin {
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

  Future<void> insertWord() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final Map<String, dynamic> wordData = jsonDecode(jsonController.text);

      final response = await http.post(
        Uri.parse('$baseUrl/words'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(wordData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          message = '✅ Word "${responseBody['english_word']}" added successfully!';
        });
      } else {
        setState(() {
          message = '❌ Error: Failed to insert word';
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
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      appBar: AppBar(
        title: const Text('Insert Word'),
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
            padding: const EdgeInsets.all(16),
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
                            maxLines: 25,
                            style: const TextStyle(color: Colors.indigo),
                            decoration: const InputDecoration(
                              labelText: 'Paste JSON here',
                              labelStyle: TextStyle(color: Colors.indigo),
                              hintText: '''{
  "_id": "68726ef73353a36f3ed789e4",
  "english_word": "ash",
  "translations": {
    "spanish": "fresno",
    "german": "Esche",
    "arabic": "رماد",
    "chinese": "灰树",
    "french": "frêne"
  },
  "image_link": "https://images.unsplash.com/photo-1642781319269-95b34e8958a8?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGFzaHxlbnwwfHwwfHx8MA%3D%3D"
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
                                insertWord();
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
                              'Insert Word',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
