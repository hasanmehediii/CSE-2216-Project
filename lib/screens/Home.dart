import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String userName; // This will hold the user's name

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Learning'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Greeting message
              Text(
                "Welcome, ${widget.userName}!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 40),

              // Language selection (button)
              ElevatedButton(
                onPressed: () {
                  // Handle the language selection logic here
                  // For now, just a placeholder
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Choose a Language"),
                        content: const Text("You can select a language to start learning."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Select a Language',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Learning progress (example progress bar)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    const Text(
                      "Your Learning Progress",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: 0.6, // Example: 60% progress
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 10),
                    Text("60% Completed", style: TextStyle(fontSize: 16, color: Colors.green)),
                  ],
                ),
              ),

              // Logout or Exit button
              ElevatedButton(
                onPressed: () {
                  // Logic for logging out or exiting
                  // Placeholder logic for now
                  Navigator.pop(context); // Goes back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
