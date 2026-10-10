import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NctbAssignmentScreen extends StatelessWidget {
  const NctbAssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> assignments = [
      {
        'title': 'Science - 4th Week Assignment',
        'class': 'Class 8',
        'subject': 'General Science',
        'issueDate': '12 Shaban',
        'deadline': '20 Shaban',
        'status': 'Grading in Progress',
        'submissions': '42/45',
        'color': Colors.orange.shade500 // Amber
      },
      {
        'title': 'Quran Majeed & Tajweed - 5th Week',
        'class': 'Dakhil Class 10',
        'subject': 'Quran Majeed',
        'issueDate': '18 Shaban',
        'deadline': '25 Shaban',
        'status': 'Receiving',
        'submissions': '15/50',
        'color': Colors.blue.shade600 // Blue
      },
      {
        'title': 'Mathematics - 3rd Week',
        'class': 'Class 7',
        'subject': 'Mathematics',
        'issueDate': '05 Shaban',
        'deadline': '12 Shaban',
        'status': 'Completed & Submitted to Board',
        'submissions': '40/40',
        'color': Colors.green.shade600 // Green
      }
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('NCTB Assignments', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.green.shade700, // Emerald
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                return _buildAssignmentCard(assignments[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.green.shade700,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text('New Assignment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.green.shade700,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Govt. Assignments Portal', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Manage weekly NCTB/Madrasah Board assignments, student submissions, and grading records.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search assignment (e.g. Science 4th Week)...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.8)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.15),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    bool isCompleted = assignment['status'].contains('Completed');
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                child: Text(assignment['class'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569))),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                child: Text(assignment['subject'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569))),
              ),
              const Spacer(),
              Icon(isCompleted ? Icons.check_circle_rounded : Icons.pending_actions_rounded, color: assignment['color'], size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(assignment['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDateColumn('Issued', assignment['issueDate']),
              Container(width: 1, height: 24, color: Colors.grey.shade300, margin: EdgeInsets.symmetric(horizontal: 16)),
              _buildDateColumn('Deadline', assignment['deadline']),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Submissions', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                  const SizedBox(height: 2),
                  Text(assignment['submissions'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current Status:', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: assignment['color'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(assignment['status'], style: TextStyle(color: assignment['color'], fontWeight: FontWeight.bold, fontSize: 11)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        const SizedBox(height: 2),
        Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF334155))),
      ],
    );
  }
}

