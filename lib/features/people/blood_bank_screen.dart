import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BloodBankScreen extends StatefulWidget {
  const BloodBankScreen({super.key});

  @override
  State<BloodBankScreen> createState() => _BloodBankScreenState();
}

class _BloodBankScreenState extends State<BloodBankScreen> {
  final List<String> _bloodGroups = ['All', 'A+', 'O+', 'B+', 'AB+', 'A-', 'O-', 'B-', 'AB-'];
  int _selectedGroupIndex = 0;

  final List<Map<String, dynamic>> _donors = [
    {
      'name': 'Maulana Tariq',
      'group': 'O+',
      'type': 'Staff',
      'lastDonation': '3 Months Ago',
      'contact': '+880 1711-000000',
    },
    {
      'name': 'Abdullah Al Mahmud',
      'group': 'A+',
      'type': 'Student (Class 8)',
      'lastDonation': 'Available',
      'contact': '+880 1811-000000',
    },
    {
      'name': 'Habibur Rahman',
      'group': 'O+',
      'type': 'Guardian',
      'lastDonation': 'Available',
      'contact': '+880 1911-000000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Madrasah Blood Bank', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFFDC2626), // Red 600
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
              itemCount: _donors.length,
              itemBuilder: (context, index) {
                return _buildDonorCard(_donors[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFFDC2626),
        icon: const Icon(Icons.emergency_rounded, color: Colors.white),
        label: const Text('Urgent Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFDC2626),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Find a Life Saver', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Search for available blood donors among our staff, students, and guardians.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 24),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _bloodGroups.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedGroupIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGroupIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? Colors.white : Colors.transparent),
                    ),
                    child: Text(
                      _bloodGroups[index],
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFDC2626) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDonorCard(Map<String, dynamic> donor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          // Blood Group Badge
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.water_drop_rounded, color: Color(0xFFDC2626), size: 16),
                const SizedBox(height: 2),
                Text(donor['group'], style: const TextStyle(color: Color(0xFFB91C1C), fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(donor['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(donor['type'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.history_rounded, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(donor['lastDonation'], style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                  ],
                )
              ],
            ),
          ),
          // Action Buttons
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: Icon(Icons.call_rounded, color: Colors.blue.shade600, size: 20),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}

