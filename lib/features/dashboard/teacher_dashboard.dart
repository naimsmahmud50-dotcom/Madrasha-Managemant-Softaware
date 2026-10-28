import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 100
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assalamu Alaikum,', style: TextStyle(fontSize: 12, color: Colors.white70)),
            Text('Teacher / Ustad', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
          ],
        ),
        backgroundColor: AppTheme.primaryBrand,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats
            Row(
              children: [
                Expanded(child: _buildStatCard('Today\'s Classes', '4', Icons.class_rounded, Colors.blue.shade600)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Pending Copies', '28', Icons.edit_document, Colors.amber.shade600)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Section Title
            Text('Upcoming Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            
            // Updates List
            _buildAlertCard(
              'Class 8 (Mutawassitah) - Arabic',
              'Room 204 • Topic: Nahw & Sarf',
              '10:30 AM',
              Icons.menu_book_rounded,
              Colors.blue.shade500,
            ),
            _buildAlertCard(
              'Staff Meeting',
              'Principal\'s Office • Discussing Term Exams',
              '02:00 PM',
              Icons.groups_rounded,
              Colors.green.shade500,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String title, String subtitle, String time, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(time, style: TextStyle(fontSize: 12, color: Colors.green.shade500, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

