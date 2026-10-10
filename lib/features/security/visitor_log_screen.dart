import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class VisitorLogScreen extends StatelessWidget {
  const VisitorLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> visitors = [
      {
        'name': 'Abdur Rahim',
        'relation': 'Father of student',
        'whomToMeet': 'Abdullah (Class 8)',
        'timeIn': '09:15 AM',
        'timeOut': '09:45 AM',
        'status': 'Left',
        'color': Colors.grey.shade600,
      },
      {
        'name': 'MD. Hasan',
        'relation': 'Supplier (Books)',
        'whomToMeet': 'Librarian',
        'timeIn': '10:30 AM',
        'timeOut': '--:--',
        'status': 'Inside',
        'color': Colors.green.shade600,
      },
      {
        'name': 'Abdul Karim',
        'relation': 'Guest',
        'whomToMeet': 'Muhtamim Hujur',
        'timeIn': '11:00 AM',
        'timeOut': '--:--',
        'status': 'Inside',
        'color': Colors.green.shade600,
      }
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Visitor Logbook', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF334155),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: visitors.length,
              itemBuilder: (context, index) {
                return _buildVisitorCard(visitors[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF334155),
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text('New Entry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF334155),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Today\'s Visitors', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Track guests, guardians, and suppliers entering the madrasah premises.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search visitor name...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVisitorCard(Map<String, dynamic> visitor) {
    bool isInside = visitor['status'] == 'Inside';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(Icons.account_circle_rounded, color: Colors.grey.shade500, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(visitor['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: visitor['color'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(visitor['status'], style: TextStyle(color: visitor['color'], fontWeight: FontWeight.bold, fontSize: 11)),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(visitor['relation'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.handshake_rounded, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text('Meeting: ${visitor['whomToMeet']}', style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: Colors.grey.shade100),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeBadge('IN', visitor['timeIn'], const Color(0xFF0F766E)),
                    _buildTimeBadge('OUT', visitor['timeOut'], isInside ? Colors.grey.shade500 : Colors.red.shade500),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimeBadge(String label, String time, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
          child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 6),
        Text(time, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

