import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BoardRegistrationScreen extends StatelessWidget {
  const BoardRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> students = [
      {
        'name': 'Md. Abdullah Al Kafi',
        'roll': 'D-2023-101',
        'exam': 'Dakhil Examination',
        'formFillUp': 'Completed',
        'feeStatus': 'Paid',
        'admitCard': 'Ready to Issue',
        'color': Colors.green.shade600, // Emerald
      },
      {
        'name': 'Fatimah Binte Rahman',
        'roll': 'A-2023-045',
        'exam': 'Alim Examination',
        'formFillUp': 'Pending',
        'feeStatus': 'Unpaid',
        'admitCard': 'Not Generated',
        'color': Colors.red.shade500, // Red
      },
      {
        'name': 'Zubair Ahmed',
        'roll': 'D-2023-102',
        'exam': 'Dakhil Examination',
        'formFillUp': 'Completed',
        'feeStatus': 'Paid',
        'admitCard': 'Issued',
        'color': Colors.blue.shade600, // Blue
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Board Exam & Reg.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.blue.shade700, // Blue 600
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                return _buildRegistrationCard(students[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.blue.shade700,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Board Registration 2026', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Track form fill-ups, board fees, and admit card distributions for Dakhil & Alim candidates.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by Name or Board Roll...',
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

  Widget _buildRegistrationCard(Map<String, dynamic> student) {
    bool isCompleted = student['formFillUp'] == 'Completed';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.school_rounded, color: Colors.grey.shade600, size: 18),
                  const SizedBox(width: 8),
                  Text(student['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                child: Text('Roll: ${student['roll']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569))),
              )
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Text(student['exam'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusIndicator('Form Fill-up', student['formFillUp'], isCompleted ? Colors.green.shade600 : Colors.red.shade500),
              _buildStatusIndicator('Board Fee', student['feeStatus'], student['feeStatus'] == 'Paid' ? Colors.green.shade600 : Colors.red.shade500),
              _buildStatusIndicator('Admit Card', student['admitCard'], student['color']),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.circle, size: 8, color: color),
            const SizedBox(width: 4),
            Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ],
    );
  }
}

