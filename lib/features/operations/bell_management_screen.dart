import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BellManagementScreen extends StatefulWidget {
  const BellManagementScreen({super.key});

  @override
  State<BellManagementScreen> createState() => _BellManagementScreenState();
}

class _BellManagementScreenState extends State<BellManagementScreen> {
  final List<Map<String, dynamic>> _bells = [
    {'title': 'Tahajjud & Fajr Wake Up', 'time': '04:30 AM', 'type': 'Hostel Bell', 'isActive': true, 'color': Colors.blue.shade600},
    {'title': 'Breakfast (Matbakh)', 'time': '07:00 AM', 'type': 'Dining Bell', 'isActive': true, 'color': Colors.orange.shade500},
    {'title': 'Morning Assembly', 'time': '08:00 AM', 'type': 'Academic Bell', 'isActive': true, 'color': Colors.green.shade600},
    {'title': '1st Period (Hifz/Kitab)', 'time': '08:30 AM', 'type': 'Academic Bell', 'isActive': true, 'color': Colors.green.shade600},
    {'title': 'Mid-day Break (Tiffin)', 'time': '11:00 AM', 'type': 'Break Bell', 'isActive': false, 'color': AppTheme.primaryBrand},
    {'title': 'Zuhr Prayer Preparation', 'time': '12:45 PM', 'type': 'Prayer Bell', 'isActive': true, 'color': const Color(0xFF0F766E)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Digital Bell System', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.textPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bells.length,
              itemBuilder: (context, index) {
                return _buildBellCard(_bells[index], index);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.textPrimary,
        icon: const Icon(Icons.add_alarm_rounded, color: Colors.white),
        label: const Text('Add Bell', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppTheme.textPrimary,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Automated Schedule', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Configure daily madrasah bells', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.green.shade600.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: const Icon(Icons.notifications_active_rounded, color: Color(0xFF34D399)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBellCard(Map<String, dynamic> bell, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bell['isActive'] ? bell['color'].withValues(alpha: 0.3) : Colors.grey.shade200, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bell['isActive'] ? bell['color'].withValues(alpha: 0.1) : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_rounded,
              color: bell['isActive'] ? bell['color'] : Colors.grey.shade500,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bell['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: bell['isActive'] ? AppTheme.textPrimary : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                      child: Text(bell['type'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.schedule_rounded, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(bell['time'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: bell['isActive'],
            activeTrackColor: bell['color'].withValues(alpha: 0.5),
            activeThumbColor: bell['color'],
            onChanged: (value) {
              setState(() {
                _bells[index]['isActive'] = value;
              });
            },
          )
        ],
      ),
    );
  }
}

