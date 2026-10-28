import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../admin/user_approval_screen.dart';
import '../people/add_student_screen.dart';
import '../setup/system_settings_screen.dart';

import 'package:flutter/services.dart'; // Added for SystemNavigator.pop

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App?'),
            content: Text('Are you sure you want to close the application?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), 
                child: Text('No', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), 
                child: Text('Yes', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ) ?? false;
        
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 100
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assalamu Alaikum,', style: TextStyle(fontSize: 12, color: Colors.white70)),
            Text('Principal / Admin', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
          ],
        ),
        backgroundColor: AppTheme.primaryBrand, // Slate 900
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_rounded, color: Colors.white),
            tooltip: 'Add Student',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddStudentScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddStudentScreen()));
        },
        backgroundColor: AppTheme.primaryBrand,
        icon: Icon(Icons.add_rounded, color: Colors.white),
        label: Text('New Student', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<AggregateQuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('students').count().get(),
                    builder: (context, snapshot) {
                      String count = '...';
                      if (snapshot.hasData && snapshot.data?.count != null) {
                        count = snapshot.data!.count!.toString();
                      }
                      return _buildStatCard('Total Students', count, Icons.groups_rounded, Colors.blue.shade600);
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Pending Users', 
                    'Check', 
                    Icons.how_to_reg_rounded, 
                    Colors.amber.shade600,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => UserApprovalScreen()));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard('Attendance Today', '92%', Icons.check_circle_rounded, Colors.green.shade600)),
                SizedBox(width: 12),
                Expanded(child: _buildStatCard('Due Fees (Est)', '৳ 45K', Icons.account_balance_wallet_rounded, Colors.red.shade600)),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Section Title
            Text('Recent Updates & Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            SizedBox(height: 12),
            
            // Recent Updates List
            _buildAlertCard(
              'New Admission Request',
              'Muhammad Abdullah applied for Class 6 (Mutawassitah).',
              '2 mins ago',
              Icons.person_add_rounded,
              Colors.blue.shade500,
            ),
            _buildAlertCard(
              'Hostel Issue Reported',
              'Fan not working in Room 302 (Abu Bakr Block).',
              '1 hour ago',
              Icons.build_rounded,
              Colors.orange.shade500,
            ),
            _buildAlertCard(
              'MPO Verification Deadline',
              'Please submit teachers\' B.Ed certificates by tomorrow.',
              '3 hours ago',
              Icons.warning_rounded,
              Colors.red.shade500,
            ),
            
            SizedBox(height: 24),
            
            // System Status
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SystemSettingsScreen()));
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.green.shade500.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: Icon(Icons.cloud_done_rounded, color: Colors.green.shade500),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('System Status & Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Tap to configure Madrasah type (Alia/Qawmi) & Database.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.softShadow,
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 12),
              ],
            ),
            SizedBox(height: 16),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(String title, String subtitle, String time, IconData icon, Color iconColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(time, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

