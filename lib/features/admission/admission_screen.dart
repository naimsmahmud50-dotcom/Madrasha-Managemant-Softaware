import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/bounce_wrapper.dart';

class AdmissionScreen extends StatefulWidget {
  const AdmissionScreen({super.key});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All Applicants', 'Pending Viva', 'Approved', 'Rejected'];

  final List<Map<String, dynamic>> _applicants = [
    {'id': 'APP-2027-001', 'name': 'Zaid Bin Harith', 'class': 'Class 6 (Hifz)', 'status': 'Pending Viva', 'date': '21 Sept', 'score': '85%'},
    {'id': 'APP-2027-002', 'name': 'Umar Farooq', 'class': 'Class 8 (Mutawassitah)', 'status': 'Approved', 'date': '20 Sept', 'score': '92%'},
    {'id': 'APP-2027-003', 'name': 'Abdullah Al Noman', 'class': 'Class 6 (Qawmi)', 'status': 'New', 'date': '22 Sept', 'score': '-'},
    {'id': 'APP-2027-004', 'name': 'Hasan Mahmud', 'class': 'Class 9 (Sanawiyyah)', 'status': 'Waitlisted', 'date': '19 Sept', 'score': '70%'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Richer, premium slate-blue background instead of plain white
      appBar: AppBar(
        title: const Text('Admissions CRM 2027', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primaryBrand,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildStatsHeader(),
          _buildTabBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _applicants.length,
              itemBuilder: (context, index) {
                final app = _applicants[index];
                return _buildApplicantCard(app);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BounceWrapper(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.orange.shade500,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.orange.shade500.withValues(alpha: 0.4), blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('New Application', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBrand,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        boxShadow: [BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.2), blurRadius: 15, offset: Offset(0, 5))],
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem('Total Apps', '450', Icons.people_alt_rounded)),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(child: _buildStatItem('Pending Viva', '120', Icons.hourglass_empty_rounded)),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(child: _buildStatItem('Enrolled', '200', Icons.check_circle_rounded)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentGold, size: 28),
        const SizedBox(height: 8),
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0EA5E9) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: isSelected ? Color(0xFF0EA5E9) : Colors.grey.shade300),
                boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF0EA5E9).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
              ),
              child: Center(
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplicantCard(Map<String, dynamic> app) {
    Color statusColor;
    switch (app['status']) {
      case 'Approved': statusColor = Colors.green.shade600; break;
      case 'Pending Viva': statusColor = Colors.orange.shade500; break;
      case 'Waitlisted': statusColor = Colors.grey.shade600; break;
      default: statusColor = Colors.blue.shade600;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.03), // Faint tinted background for a premium look
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: statusColor.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: statusColor.withValues(alpha: 0.15),
                  child: Text(app['name'][0], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(app['id'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          Text(app['date'], style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(app['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text(app['class'], style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: statusColor.withValues(alpha: 0.1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment_turned_in_rounded, size: 16, color: statusColor),
                    const SizedBox(width: 6),
                    Text('Test Score: ${app['score']}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                  child: Text(app['status'], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

