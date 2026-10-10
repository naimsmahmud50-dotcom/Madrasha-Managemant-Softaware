import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class AdmissionScreen extends StatelessWidget {
  const AdmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50, // Green 50
      appBar: AppBar(
        title: Text('Admission Management', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Color(0xFF0F766E), // Teal 700
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeaderStats(),
          SizedBox(height: 16),
          _buildSessionSelector(),
          SizedBox(height: 24),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RECENT APPLICATIONS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF115E59), letterSpacing: 1.2)),
                  SizedBox(height: 16),
                  
                  _buildApplicantCard(
                    name: 'Abdullah Al Noman',
                    appliedFor: 'Hifz Department',
                    date: 'Today, 10:30 AM',
                    status: 'Pending Review',
                    statusColor: Colors.orange.shade500,
                  ),
                  _buildApplicantCard(
                    name: 'Muhammad Anas',
                    appliedFor: 'Class 6 (General)',
                    date: 'Yesterday, 04:15 PM',
                    status: 'Viva Scheduled',
                    statusColor: Colors.blue.shade600,
                  ),
                  _buildApplicantCard(
                    name: 'Zaid bin Thabit',
                    appliedFor: 'Maktab (Noorani)',
                    date: '20 Sept 2026',
                    status: 'Selected',
                    statusColor: Colors.green.shade600,
                  ),
                  _buildApplicantCard(
                    name: 'Omar Faruq',
                    appliedFor: 'Class 7',
                    date: '18 Sept 2026',
                    status: 'Pending Review',
                    statusColor: Colors.orange.shade500,
                  ),
                  
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStats() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF0F766E),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Color(0xFF0F766E).withValues(alpha: 0.3), blurRadius: 15, offset: Offset(0, 5))],
      ),
      child: Column(
        children: [
          Text('Total Applications (Session 2026-27)', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Text('342', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildMiniStatCard('Selected', '145', Icons.how_to_reg_rounded, Colors.green.shade600)),
              SizedBox(width: 12),
              Expanded(child: _buildMiniStatCard('Pending', '87', Icons.hourglass_top_rounded, Color(0xFFFCD34D))),
              SizedBox(width: 12),
              Expanded(child: _buildMiniStatCard('Viva', '110', Icons.record_voice_over_rounded, Colors.blue.shade600)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(String title, String amount, IconData icon, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          SizedBox(height: 8),
          Text(amount, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildSessionSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF0F766E).withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, color: Color(0xFF0F766E), size: 20),
                SizedBox(width: 12),
                Text('Session 2026-27', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
              ],
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantCard({
    required String name,
    required String appliedFor,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return BounceWrapper(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                  child: Icon(Icons.person_outline_rounded, color: statusColor),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand), maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 2),
                      Text('Applied for: $appliedFor', style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.grey.shade100, height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade500),
                    SizedBox(width: 4),
                    Text(date, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

