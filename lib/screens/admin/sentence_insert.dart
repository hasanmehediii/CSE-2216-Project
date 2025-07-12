import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SentenceInsert extends StatefulWidget {
  const SentenceInsert({super.key});

  @override
  State<SentenceInsert> createState() => _SentenceInsertState();
}

class _SentenceInsertState extends State<SentenceInsert> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController jsonController = TextEditingController();
  bool isLoading = false;
  String message = '';

  final String baseUrl = '${dotenv.env['BASE_URL']!}/admin';

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
          message = 'Sentence inserted successfully!';
        });
      } else {
        setState(() {
          message = 'Error: Failed to insert sentence';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Invalid JSON format. Please check the data.';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert Sentence'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: jsonController,
                maxLines: 20,
                decoration: const InputDecoration(
                  labelText: 'Paste Sentence JSON here',
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
              if (isLoading)
                const CircularProgressIndicator()
              else if (message.isNotEmpty)
                Text(
                  message,
                  style: TextStyle(
                    color: message.contains('Error') ? Colors.red : Colors.green,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    insertSentence();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Insert Sentence',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
