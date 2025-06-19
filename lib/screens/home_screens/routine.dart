import 'package:flutter/material.dart';

/// A data model representing a work or learning task.
class WorkTask {
  final String title;
  final String time;
  final String duration;
  String status; // Added status to demonstrate state change

  WorkTask({
    required this.title,
    required this.time,
    required this.duration,
    this.status = 'Pending', // Default status
  });
}

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<WorkTask> _tasks = [
    WorkTask(title: 'Complete Spanish Lesson', time: '09:00 AM', duration: '1 hour'),
    WorkTask(title: 'Vocabulary Review', time: '11:00 AM', duration: '30 mins'),
    WorkTask(title: 'Group Practice Session', time: '02:00 PM', duration: '1.5 hours'),
    WorkTask(title: 'Grammar Exercises', time: '04:30 PM', duration: '45 mins'),
    WorkTask(title: 'Speaking Practice', time: '06:00 PM', duration: '1 hour'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper widget for status buttons within the task details dialog
  Widget _buildStatusButton(String statusText, Color color, WorkTask task) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            setState(() {
              task.status = statusText;
            });
            Navigator.of(context).pop(); // Close the dialog
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
        title: const Text('Routine & Schedule'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.school), text: 'Class Routine'),
            Tab(icon: Icon(Icons.work), text: 'Work Schedule'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Class Routine Tab
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 60, color: Colors.teal),
                SizedBox(height: 20),
                Text(
                  'Class Routine',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Monday: 9:00 AM - Spanish\n'
                      'Tuesday: 11:00 AM - Vocabulary\n'
                      'Wednesday: 2:00 PM - Conversation\n'
                      'Thursday: 4:00 PM - Grammar\n'
                      'Friday: 10:00 AM - Review',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),

          // Work Schedule Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Work Schedule',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Manage your learning tasks and deadlines',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Icon(Icons.assignment, color: Colors.teal),
                          title: Text(task.title),
                          subtitle: Text('${task.time} • ${task.duration} • Status: ${task.status}'), // Display status
                          trailing: IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Reminder set for ${task.title}')),
                              );
                            },
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(task.title),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Time: ${task.time}'),
                                    Text('Duration: ${task.duration}'),
                                    const SizedBox(height: 20),
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
                        ),
                      );
                    },
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