import 'package:flutter/material.dart';

/// A data model for a to-do task.
class ToDoTask {
  final String title;
  String status;

  ToDoTask({required this.title, this.status = 'Pending'});
}

/// A data model for a day's to-do list.
class Day {
  final String dayLabel;
  final List<ToDoTask> tasks;

  Day({required this.dayLabel, required this.tasks});
}

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  // List of 10 days with tasks
  final List<Day> _days = [
    Day(dayLabel: 'Day 1', tasks: [
      ToDoTask(title: 'Watch Video'),
      ToDoTask(title: 'Learn Pronunciation'),
    ]),
    Day(dayLabel: 'Day 2', tasks: [
      ToDoTask(title: 'Participate in MCQ Exam'),
      ToDoTask(title: 'Play Flash Card'),
    ]),
    Day(dayLabel: 'Day 3', tasks: [
      ToDoTask(title: 'Play Sentence Builder'),
      ToDoTask(title: 'MCQ Test'),
      ToDoTask(title: 'Memorise'),
    ]),
    Day(dayLabel: 'Day 4', tasks: [
      ToDoTask(title: 'Grammar Exercises'),
      ToDoTask(title: 'Speaking Practice'),
    ]),
    Day(dayLabel: 'Day 5', tasks: [
      ToDoTask(title: 'Vocabulary Review'),
      ToDoTask(title: 'Group Discussion'),
    ]),
    Day(dayLabel: 'Day 6', tasks: [
      ToDoTask(title: 'Watch Tutorial Video'),
      ToDoTask(title: 'Practice Writing'),
    ]),
    Day(dayLabel: 'Day 7', tasks: [
      ToDoTask(title: 'MCQ Quiz'),
      ToDoTask(title: 'Play Word Puzzle'),
    ]),
    Day(dayLabel: 'Day 8', tasks: [
      ToDoTask(title: 'Listening Practice'),
      ToDoTask(title: 'Review Notes'),
    ]),
    Day(dayLabel: 'Day 9', tasks: [
      ToDoTask(title: 'Sentence Correction'),
      ToDoTask(title: 'Speaking Drill'),
    ]),
    Day(dayLabel: 'Day 10', tasks: [
      ToDoTask(title: 'Comprehensive Review'),
      ToDoTask(title: 'Mock Test'),
    ]),
  ];

  // Helper method for status buttons
  Widget _buildStatusButton(String statusText, Color color, ToDoTask task) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            setState(() {
              task.status = statusText;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task "${task.title}" set to: $statusText')),
            );
          },
          child: Text(statusText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your 10-Day Learning Plan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tap a day to view tasks',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today, color: Colors.teal),
                      title: Text(day.dayLabel),
                      subtitle: Text('Tasks: ${day.tasks.length}'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(day.dayLabel),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Tasks:'),
                                  const SizedBox(height: 10),
                                  ...day.tasks.map((task) => ListTile(
                                    title: Text(task.title),
                                    subtitle: Text('Status: ${task.status}'),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(task.title),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Set status:'),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  _buildStatusButton('Pending', Colors.orange, task),
                                                  _buildStatusButton('In Progress', Colors.blue, task),
                                                  _buildStatusButton('Completed', Colors.green, task),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}