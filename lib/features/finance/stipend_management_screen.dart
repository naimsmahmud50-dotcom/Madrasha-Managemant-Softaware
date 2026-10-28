import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StipendManagementScreen extends StatelessWidget {
  const StipendManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stipendList = [
      {
        'name': 'Hafiza Khatun',
        'class': 'Class 6 - Dakhil',
        'accountType': 'bKash',
        'accountNumber': '01711-XXXXXX',
        'amount': '৳ 2,400',
        'status': 'Disbursed',
        'color': Colors.green.shade600 // Green
      },
      {
        'name': 'Omar Faruq',
        'class': 'Class 9 - Science',
        'accountType': 'Nagad',
        'accountNumber': '01811-XXXXXX',
        'amount': '৳ 3,000',
        'status': 'Pending Approval',
        'color': Colors.orange.shade500 // Amber
      },
      {
        'name': 'Sumaiya Binte Hasan',
        'class': 'Alim 1st Year',
        'accountType': 'Bank Account',
        'accountNumber': '2050XXXXXXXXXXXX',
        'amount': '৳ 4,500',
        'status': 'Rejected (Info Error)',
        'color': Colors.red.shade500 // Red
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Govt. Stipend (à¦‰à¦ªà¦¬à§ƒà¦¤à§à¦¤à¦¿)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF0EA5E9), // Sky Blue
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stipendList.length,
              itemBuilder: (context, index) {
                return _buildStipendCard(stipendList[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF0EA5E9),
        icon: const Icon(Icons.add_card_rounded, color: Colors.white),
        label: const Text('Add Nominee', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF0EA5E9),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildStat('Total Nominees', '452')),
              Container(width: 1, height: 30, color: Colors.white24),
              Expanded(child: _buildStat('Disbursed', '410')),
              Container(width: 1, height: 30, color: Colors.white24),
              Expanded(child: _buildStat('Pending', '42')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by Mobile/Bank A/C...',
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

  Widget _buildStat(String title, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStipendCard(Map<String, dynamic> stipend) {
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
              Text(stipend['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
              Text(stipend['amount'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0EA5E9))),
            ],
          ),
          const SizedBox(height: 4),
          Text(stipend['class'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet_rounded, size: 14, color: stipend['accountType'] == 'bKash' ? Color(0xFFE11471) : (stipend['accountType'] == 'Nagad' ? Color(0xFFEA580C) : Colors.grey.shade600)),
                      const SizedBox(width: 6),
                      Text(stipend['accountType'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(stipend['accountNumber'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: stipend['color'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(stipend['status'], style: TextStyle(color: stipend['color'], fontWeight: FontWeight.bold, fontSize: 11)),
              )
            ],
          )
        ],
      ),
    );
  }
}

