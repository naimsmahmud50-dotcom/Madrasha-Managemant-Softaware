import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CommitteeBoardScreen extends StatelessWidget {
  const CommitteeBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> members = [
      {
        'name': 'Alhaj Abdur Rahman',
        'role': 'President (Sadar)',
        'type': 'Shura Member',
        'contact': '+880 1711-XXXXXX',
        'color': const Color(0xFF0F766E),
      },
      {
        'name': 'Mufti Abdullah',
        'role': 'Secretary (Nazim)',
        'type': 'Majlis-e-Aamela',
        'contact': '+880 1811-XXXXXX',
        'color': Colors.blue.shade600,
      },
      {
        'name': 'Haji Salimullah',
        'role': 'Treasurer (Mutawalli)',
        'type': 'Shura Member',
        'contact': '+880 1911-XXXXXX',
        'color': Colors.orange.shade500,
      }
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Shura & Committee Board', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.textPrimary, // Slate 800
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildMeetingCard(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Board Members', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: members.length,
              itemBuilder: (context, index) {
                return _buildMemberCard(members[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.textPrimary,
        child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildMeetingCard() {
    return Container(
      width: double.infinity,
      color: AppTheme.textPrimary,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.shade600.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Upcoming Meeting', style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                const Spacer(),
                const Icon(Icons.more_horiz_rounded, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Annual Budget & Expansion Review', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                const Text('25 Shaban, 1447', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const Spacer(),
                const Icon(Icons.access_time_rounded, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                const Text('10:00 AM', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
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
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: member['color'].withValues(alpha: 0.1),
            child: Text(member['name'].substring(0, 1), style: TextStyle(color: member['color'], fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(member['role'], style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: Text(member['type'], style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 11)),
          )
        ],
      ),
    );
  }
}

