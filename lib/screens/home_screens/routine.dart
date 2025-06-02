import 'package:flutter/material.dart';

class RoutinePage extends StatelessWidget {
  const RoutinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Routine")),
      body: const Center(
        child: Text("Routine schedule will be displayed here!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}