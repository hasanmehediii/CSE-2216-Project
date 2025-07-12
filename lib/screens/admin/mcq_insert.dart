import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class McqInsert extends StatefulWidget {
  const McqInsert({super.key});

  @override
  State<McqInsert> createState() => _McqInsertState();
}

class _McqInsertState extends State<McqInsert> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController jsonController = TextEditingController();
  bool isLoading = false;
  String message = '';

  final String baseUrl = '${dotenv.env['BASE_URL']!}/admin';

  Future<void> insertMcq() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final Map<String, dynamic> mcqData = jsonDecode(jsonController.text);

      final response = await http.post(
        Uri.parse('$baseUrl/mcq'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(mcqData),
      );

      if (response.statusCode == 200) {
        setState(() {
          message = 'MCQ inserted successfully!';
        });
      } else {
        setState(() {
          message = 'Error: Failed to insert MCQ';
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
        title: const Text('Insert MCQ'),
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
                maxLines: 25,
                decoration: const InputDecoration(
                  labelText: 'Paste MCQ JSON here',
                  hintText: '''{
  "_id": "687276333353a36f3ed789e7",
  "question": "The meaning of 'tree' in {selected_language} is:",
  "languages": {
    "spanish": {
      "options": [
        "casa",
        "árbol",
        "coche",
        "sol"
      ],
      "answer_index": { "numberInt": "1" }
    },
    "german": {
      "options": [
        "Haus",
        "Baum",
        "Auto",
        "Sonne"
      ],
      "answer_index": { "numberInt": "1" }
    },
    "chinese": {
      "options": ["房子", "树", "车", "太阳"],
      "answer_index": { "numberInt": "1" }
    },
    "arabic": {
      "options": ["بيت", "شجرة", "سيارة", "شمس"],
      "answer_index": { "numberInt": "1" }
    },
    "french": {
      "options": [
        "maison",
        "arbre",
        "voiture",
        "soleil"
      ],
      "answer_index": { "numberInt": "1" }
    }
  }
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
                    insertMcq();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Insert MCQ',
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
