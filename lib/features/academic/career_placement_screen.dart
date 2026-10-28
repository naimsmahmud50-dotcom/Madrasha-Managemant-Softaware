import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CareerPlacementScreen extends StatelessWidget {
  const CareerPlacementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> jobs = [
      {
        'title': 'Khatib & Head Imam',
        'location': 'Central Mosque, Gulshan',
        'type': 'Full Time',
        'salary': 'Negotiable',
        'deadline': '25 Shaban, 1447',
        'color': const Color(0xFF0F766E), // Teal
      },
      {
        'title': 'Senior Muhaddith (Hadith Teacher)',
        'location': 'Jamia Islamia, Dhaka',
        'type': 'Full Time',
        'salary': '৳30,000 - ৳45,000',
        'deadline': '30 Shaban, 1447',
        'color': const Color(0xFF4F46E5), // Indigo
      },
      {
        'title': 'Part-time Hifz Teacher',
        'location': 'Madani Maktab, Mirpur',
        'type': 'Part Time (Afternoon)',
        'salary': '৳15,000',
        'deadline': 'Urgent',
        'color': Colors.orange.shade500, // Amber
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Career & Placement', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF0F766E), // Teal
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                return _buildJobCard(jobs[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF0F766E),
        icon: const Icon(Icons.description_rounded, color: Colors.white),
        label: const Text('Upload CV', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF0F766E),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fuzalaa Placement Board', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Exclusive career opportunities for Madrasah graduates (Imam, Khatib, Teachers).', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search jobs (e.g. Imam)...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.7)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: job['color'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.work_outline_rounded, color: job['color'], size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(job['location'], style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildTag(job['type'], Colors.grey.shade100, Color(0xFF475569)),
              const SizedBox(width: 8),
              _buildTag(job['salary'], Colors.green.shade50, Colors.green.shade700),
            ],
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deadline', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  const SizedBox(height: 2),
                  Text(job['deadline'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                ],
              ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: job['color'],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Apply Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

