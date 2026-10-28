import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/providers/active_student_provider.dart';
import '../finance/fees_screen.dart';

class GuardianDashboard extends ConsumerStatefulWidget {
  const GuardianDashboard({super.key});

  @override
  ConsumerState<GuardianDashboard> createState() => _GuardianDashboardState();
}

class _GuardianDashboardState extends ConsumerState<GuardianDashboard> {
  @override
  Widget build(BuildContext context) {
    final activeStudent = ref.watch(activeStudentProvider);
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assalamu Alaikum,', style: TextStyle(fontSize: 12, color: Colors.white70)),
            Text('Respected Guardian', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
          ],
        ),
        backgroundColor: AppTheme.primaryBrand,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Children', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            _buildChildrenSelector(currentUid, activeStudent),
            
            const SizedBox(height: 24),
            // Quick Stats
            Row(
              children: [
                Expanded(child: _buildStatCard('Enrolled Children', '2', Icons.family_restroom_rounded, AppTheme.primaryBrand)),
                const SizedBox(width: 12),
                Expanded(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeesScreen(role: 'Guardian'))), child: _buildStatCard('Total Dues', '৳ 0.00', Icons.check_circle_rounded, Colors.green.shade500))),
              ],
            ),
            const SizedBox(height: 24),
            
            // Section Title
            Text(activeStudent != null ? 'Updates for ${activeStudent['name']}' : 'Children Updates & Notices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            
            // Updates List (Mocked but personalized if active student is selected)
            if (activeStudent != null) ...[
              _buildAlertCard(
                'Attendance Update',
                '${activeStudent['name']} reached Madrasah at 08:45 AM.',
                'Security',
                Icons.security_rounded,
                Colors.green.shade600,
              ),
              _buildAlertCard(
                'Term Exam Results',
                'Results for ${activeStudent['name']} have been published.',
                'Academic',
                Icons.grade_rounded,
                Colors.orange.shade500,
              ),
            ] else ...[
              _buildAlertCard(
                'PTM Meeting on Friday',
                'Parent-Teacher Meeting for all classes.',
                'Notice',
                Icons.groups_rounded,
                Colors.blue.shade500,
              ),
            ],
            
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenSelector(String? currentUid, Map<String, dynamic>? activeStudent) {
    // If no UID is logged in via proper Firebase Auth, we fallback to a mock stream or mock list
    // To ensure prototype functionality without complex backend setup, we mix real and mock.
    
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('students')
          .where('guardianUid', isEqualTo: currentUid ?? 'mock_guardian')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Mock data if Firestore is empty to showcase the Multi-student linking feature
        List<Map<String, dynamic>> childrenData = [];
        
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          childrenData = snapshot.data!.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
        } else {
          childrenData = [
            {'id': 's1', 'name': 'Abdullah', 'class': 'Class 8', 'avatar': 'ðŸ‘¦'},
            {'id': 's2', 'name': 'Umar', 'class': 'Class 5', 'avatar': 'ðŸ‘¦'},
          ];
        }

        // Auto-select first child if none selected
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (activeStudent == null && childrenData.isNotEmpty) {
            ref.read(activeStudentProvider.notifier).setStudent(childrenData.first);
          }
        });

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childrenData.length,
            itemBuilder: (context, index) {
              final child = childrenData[index];
              final isSelected = activeStudent?['id'] == child['id'];

              return GestureDetector(
                onTap: () {
                  ref.read(activeStudentProvider.notifier).setStudent(child);
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBrand : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppTheme.primaryBrand : Colors.grey.shade200),
                    boxShadow: [
                      if (isSelected) AppTheme.softShadow[0]
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(child['avatar'] ?? 'ðŸ‘¨â€ðŸŽ“', style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(
                        child['name'] ?? 'Student',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        child['class'] ?? 'Class',
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String title, String subtitle, String category, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(category, style: TextStyle(fontSize: 10, color: iconColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

