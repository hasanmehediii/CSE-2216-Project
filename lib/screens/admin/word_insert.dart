import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WordInsert extends StatefulWidget {
  const WordInsert({super.key});

  @override
  _WordInsertState createState() => _WordInsertState();
}

class _WordInsertState extends State<WordInsert> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController jsonController = TextEditingController();
  bool isLoading = false;
  String message = '';

  final String baseUrl = '${dotenv.env['BASE_URL']!}/admin';

  Future<void> insertWord() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      // Parsing the pasted JSON
      final Map<String, dynamic> wordData = jsonDecode(jsonController.text);

      final response = await http.post(
        Uri.parse('$baseUrl/words'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(wordData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          message = 'Word "${responseBody['english_word']}" added successfully!';
        });
      } else {
        setState(() {
          message = 'Error: Failed to insert word';
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
        title: const Text('Insert Word'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(  // Allow scrolling when the keyboard appears
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // JSON Input Field
                TextFormField(
                  controller: jsonController,
                  maxLines:25,
                  decoration: const InputDecoration(
                    labelText: 'Paste JSON here',
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

                // Loading Indicator
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (message.isNotEmpty)
                  Center(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: message.contains('Error') ? Colors.red : Colors.green,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Insert Word Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      insertWord();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Insert Word',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,  // Make the text bold
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
