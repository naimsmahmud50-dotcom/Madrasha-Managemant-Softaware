import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Prepare Exam Questions (Class 8)',
      'deadline': 'Tomorrow, 10:00 AM',
      'priority': 'High',
      'isCompleted': false,
      'color': Colors.red.shade500,
    },
    {
      'title': 'Check Nahw Copies',
      'deadline': '25 Shaban',
      'priority': 'Medium',
      'isCompleted': false,
      'color': Colors.orange.shade500,
    },
    {
      'title': 'Submit Monthly Lesson Plan',
      'deadline': '15 Shaban',
      'priority': 'Normal',
      'isCompleted': true,
      'color': Colors.blue.shade600,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Tasks & To-Do', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.textPrimary, // Slate 800
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return _buildTaskCard(_tasks[index], index);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.textPrimary,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text('New Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    int pendingCount = _tasks.where((t) => !t['isCompleted']).length;
    return Container(
      width: double.infinity,
      color: AppTheme.textPrimary,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You have $pendingCount pending tasks', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Text(pendingCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const Text('In Progress', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Colors.green.shade600.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Text(_tasks.where((t) => t['isCompleted']).length.toString(), style: const TextStyle(color: Color(0xFF34D399), fontSize: 24, fontWeight: FontWeight.bold)),
                      const Text('Completed', style: TextStyle(color: Color(0xFF34D399), fontSize: 12)),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    bool isCompleted = task['isCompleted'];
    Color priorityColor = task['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: GestureDetector(
          onTap: () {
            setState(() {
              _tasks[index]['isCompleted'] = !isCompleted;
            });
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Colors.green.shade600 : Colors.transparent,
              border: Border.all(color: isCompleted ? Colors.green.shade600 : Colors.grey.shade300, width: 2),
            ),
            child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
          ),
        ),
        title: Text(
          task['title'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isCompleted ? Colors.grey.shade400 : AppTheme.textPrimary,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(task['deadline'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(task['priority'], style: TextStyle(color: priorityColor, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

