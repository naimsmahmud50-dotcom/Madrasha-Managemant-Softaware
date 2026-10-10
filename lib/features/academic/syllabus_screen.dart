import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  final List<Map<String, dynamic>> _syllabusData = [
    {
      'subject': 'Sahih Al-Bukhari (Vol 1)',
      'teacher': 'Mufti Tariq Jameel',
      'progress': 0.65,
      'status': 'On Track',
      'totalChapters': 97,
      'completedChapters': 63,
      'color': const Color(0xFF0F766E), // Teal
    },
    {
      'subject': 'Hidayah (Part 3)',
      'teacher': 'Maulana Khalid Saifullah',
      'progress': 0.40,
      'status': 'Slightly Behind',
      'totalChapters': 45,
      'completedChapters': 18,
      'color': Colors.orange.shade500, // Amber
    },
    {
      'subject': 'Tafseer-e-Jalalayn',
      'teacher': 'Ustadh Mahmud Khalil',
      'progress': 0.85,
      'status': 'Ahead',
      'totalChapters': 30,
      'completedChapters': 25,
      'color': Colors.blue.shade600, // Blue
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Syllabus Tracker', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF0F766E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Academic Year 1446-1447 AH', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
            const SizedBox(height: 8),
            Text('Class 8 (Mutawassitah)', style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ..._syllabusData.map((data) => _buildSyllabusCard(data)),
          ],
        ),
      ),
    );
  }

  Widget _buildSyllabusCard(Map<String, dynamic> data) {
    final Color mainColor = data['color'];
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['subject'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.person_rounded, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(data['teacher'], style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: mainColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(data['status'], style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 11)),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress: ${(data['progress'] * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF334155))),
              Text('${data['completedChapters']} / ${data['totalChapters']} Chapters', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: data['progress'],
              minHeight: 10,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
            ),
          )
        ],
      ),
    );
  }
}

