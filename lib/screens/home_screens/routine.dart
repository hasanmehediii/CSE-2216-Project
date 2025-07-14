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
  // List of colors for each day
  final List<List<Color>> _dayColors = [
    [Colors.teal.shade400, Colors.teal.shade700], // Day 1
    [Colors.blue.shade400, Colors.blue.shade700], // Day 2
    [Colors.purple.shade400, Colors.purple.shade700], // Day 3
    [Colors.indigo.shade400, Colors.indigo.shade700], // Day 4
    [Colors.green.shade400, Colors.green.shade700], // Day 5
    [Colors.cyan.shade400, Colors.cyan.shade700], // Day 6
    [Colors.deepPurple.shade400, Colors.deepPurple.shade700], // Day 7
    [Colors.blueGrey.shade400, Colors.blueGrey.shade700], // Day 8
    [Colors.lime.shade400, Colors.lime.shade700], // Day 9
    [Colors.amber.shade400, Colors.amber.shade700], // Day 10
  ];

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
  Widget _buildStatusButton(String statusText, Color color, IconData icon, ToDoTask task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          minimumSize: const Size(90, 40), // Constrain button size
        ),
        onPressed: () {
          setState(() {
            task.status = statusText;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task "${task.title}" set to: $statusText'),
              backgroundColor: color,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(
              statusText,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '10-Day Learning Plan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Learning Journey',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap a day to view and manage tasks',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _days.length,
                  itemBuilder: (context, index) {
                    final day = _days[index];
                    final colors = _dayColors[index % _dayColors.length];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: colors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: Icon(Icons.calendar_today, color: colors[0], size: 24),
                          ),
                          title: Text(
                            day.dayLabel,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Tasks: ${day.tasks.length} | Completed: ${day.tasks.where((t) => t.status == 'Completed').length}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                backgroundColor: Colors.white.withOpacity(0.95),
                                title: Text(
                                  day.dayLabel,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: colors[0],
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tasks (${day.tasks.length}):',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 12),
                                      ...day.tasks.map((task) => Card(
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          title: Text(
                                            task.title,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            'Status: ${task.status}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: task.status == 'Completed'
                                                  ? Colors.green
                                                  : task.status == 'In Progress'
                                                  ? Colors.blue
                                                  : Colors.orange,
                                            ),
                                          ),
                                          trailing: Icon(
                                            task.status == 'Completed'
                                                ? Icons.check_circle
                                                : task.status == 'In Progress'
                                                ? Icons.hourglass_top
                                                : Icons.pending,
                                            color: task.status == 'Completed'
                                                ? Colors.green
                                                : task.status == 'In Progress'
                                                ? Colors.blue
                                                : Colors.orange,
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                backgroundColor: Colors.white.withOpacity(0.95),
                                                title: Text(
                                                  task.title,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: colors[0],
                                                  ),
                                                ),
                                                content: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
                                                          'Set Task Status:',
                                                          style: TextStyle(fontSize: 16),
                                                        ),
                                                        const SizedBox(height: 12),
                                                        Wrap(
                                                          spacing: 8.0,
                                                          runSpacing: 8.0,
                                                          alignment: WrapAlignment.center,
                                                          children: [
                                                            _buildStatusButton('Pending', Colors.orange, Icons.pending, task),
                                                            _buildStatusButton('In Progress', Colors.blue, Icons.hourglass_top, task),
                                                            _buildStatusButton('Completed', Colors.green, Icons.check_circle, task),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: const Text(
                                                      'Close',
                                                      style: TextStyle(color: Colors.teal, fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(color: Colors.teal, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}