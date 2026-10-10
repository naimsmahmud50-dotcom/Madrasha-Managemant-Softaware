import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DisciplinaryScreen extends StatelessWidget {
  const DisciplinaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> records = [
      {
        'studentName': 'Ahsan Habib',
        'class': 'Hifz - Section B',
        'date': '20 Shaban, 1447',
        'incident': 'Absent from Fajr Jamaat in Hostel',
        'actionTaken': 'Warning (1st)',
        'color': Colors.orange.shade500,
      },
      {
        'studentName': 'Zaid Bin Tariq',
        'class': 'Class 9',
        'date': '18 Shaban, 1447',
        'incident': 'Brought Mobile Phone to Class',
        'actionTaken': 'Phone Confiscated & Guardian Called',
        'color': Colors.red.shade500,
      },
      {
        'studentName': 'Omar Faruq',
        'class': 'Alim 1st Year',
        'date': '15 Shaban, 1447',
        'incident': 'Excellent Akhlaq & Khidmah',
        'actionTaken': 'Appreciation Award',
        'color': Colors.green.shade600,
      }
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Disciplinary & Akhlaq', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF475569), // Slate 600
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                return _buildRecordCard(records[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF475569),
        icon: const Icon(Icons.gavel_rounded, color: Colors.white),
        label: const Text('New Entry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF475569),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tarbiya & Discipline Records', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Track student conduct, rules violations, and exceptional akhlaq.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search student...',
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

  Widget _buildRecordCard(Map<String, dynamic> record) {
    bool isPositive = record['color'] == Colors.green.shade600;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: record['color'].withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(isPositive ? Icons.star_rounded : Icons.warning_rounded, color: record['color'], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record['studentName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                    const SizedBox(height: 2),
                    Text(record['class'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Text(record['date'], style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Incident / Reason:', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(record['incident'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                const SizedBox(height: 12),
                Text('Action Taken:', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(record['actionTaken'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: record['color'])),
              ],
            ),
          )
        ],
      ),
    );
  }
}

