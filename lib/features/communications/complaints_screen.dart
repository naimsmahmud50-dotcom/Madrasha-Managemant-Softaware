import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final List<Map<String, dynamic>> _complaints = [
    {
      'id': 'TKT-1029',
      'title': 'Ceiling Fan not working in Room 201',
      'category': 'Maintenance',
      'date': '20 Shaban, 1447',
      'status': 'Open',
      'color': Colors.red.shade500 // Red
    },
    {
      'id': 'TKT-1028',
      'title': 'Library book request: Fathul Bari',
      'category': 'Academic',
      'date': '18 Shaban, 1447',
      'status': 'In Progress',
      'color': Colors.orange.shade500 // Amber
    },
    {
      'id': 'TKT-1025',
      'title': 'Water tap leaking in Wudu area',
      'category': 'Plumbing',
      'date': '15 Shaban, 1447',
      'status': 'Resolved',
      'color': Colors.green.shade600 // Green
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Helpdesk & Complaints', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF334155), // Slate 700
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _complaints.length,
              itemBuilder: (context, index) {
                return _buildTicketCard(_complaints[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF334155),
        icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
        label: const Text('New Complaint', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          const Text('Your Active Tickets', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Track the status of your submitted complaints, suggestions, or maintenance requests.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStatChip('All', 5, true),
              const SizedBox(width: 12),
              _buildStatChip('Open', 1, false),
              const SizedBox(width: 12),
              _buildStatChip('Resolved', 4, false),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.white : Colors.transparent),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFF334155) : Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: isSelected ? Colors.grey.shade300 : Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
            child: Text(count.toString(), style: TextStyle(color: isSelected ? const Color(0xFF334155) : Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ticket['id'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: ticket['color'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(ticket['status'], style: TextStyle(color: ticket['color'], fontWeight: FontWeight.bold, fontSize: 11)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(ticket['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.category_rounded, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(ticket['category'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(ticket['date'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          )
        ],
      ),
    );
  }
}

