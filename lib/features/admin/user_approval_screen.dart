import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

class UserApprovalScreen extends StatelessWidget {
  const UserApprovalScreen({super.key});

  Future<void> _updateStatus(BuildContext context, String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({'status': newStatus});
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(newStatus == 'Approved' ? Icons.check_circle : Icons.cancel, color: Colors.white),
              SizedBox(width: 12),
              Text('User $newStatus Successfully', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
          backgroundColor: newStatus == 'Approved' ? Colors.green.shade600 : Colors.red.shade500,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          elevation: 10,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red.shade500, behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Pending Approvals', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -0.5)),
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
        elevation: 0,
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade100, Color(0xFFE0E7FF), Colors.grey.shade100], // Premium subtle mix of slate and indigo
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('status', isEqualTo: 'Pending')
                .limit(50)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5)));
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 70, color: Colors.redAccent.shade200),
                      SizedBox(height: 16),
                      Text('Connection Lost', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text('${snapshot.error}', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, height: 1.5)),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Color(0xFF4F46E5).withValues(alpha: 0.1), blurRadius: 40, offset: Offset(0, 20))
                          ]
                        ),
                        child: Icon(Icons.check_circle_outline_rounded, size: 90, color: Colors.green.shade600),
                      ),
                      SizedBox(height: 30),
                      Text('Inbox Zero!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5)),
                      SizedBox(height: 10),
                      Text('You have cleared all pending requests.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              }

              final users = snapshot.data!.docs.toList();
              
              users.sort((a, b) {
                final aData = a.data() as Map<String, dynamic>;
                final bData = b.data() as Map<String, dynamic>;
                final aTime = aData['createdAt'] as Timestamp?;
                final bTime = bData['createdAt'] as Timestamp?;
                
                if (aTime == null && bTime == null) return 0;
                if (aTime == null) return -1; 
                if (bTime == null) return 1;
                return bTime.compareTo(aTime); 
              });

              return ListView.builder(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 40),
                physics: BouncingScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final userData = users[index].data() as Map<String, dynamic>;
                  final docId = users[index].id;
                  
                  final phone = userData['phone'] ?? 'Unknown Phone';
                  final role = userData['role'] ?? 'Unknown';
                  final date = userData['createdAt'] != null 
                      ? _formatDate((userData['createdAt'] as Timestamp).toDate())
                      : 'Just now';
                      
                  final sName = userData['studentName'];
                  final sClass = userData['studentClass'];
                  final sRoll = userData['studentRoll'];
                  final relation = userData['relation'];

                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF4F46E5).withValues(alpha: 0.06), blurRadius: 30, offset: Offset(0, 15)),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Role Badge & Date
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(role).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(_getRoleIcon(role), size: 16, color: _getRoleColor(role)),
                                        SizedBox(width: 8),
                                        Text(
                                          role.toUpperCase(), 
                                          style: TextStyle(color: _getRoleColor(role), fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(height: 24),
                              
                              // Phone Number
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(Icons.phone_iphone_rounded, color: Color(0xFF475569), size: 28),
                                  ),
                                  SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Registered Number', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                                        SizedBox(height: 4),
                                        Text(
                                          phone, 
                                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryBrand, letterSpacing: 0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              if (sName != null && sName.toString().isNotEmpty) ...[
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person_pin_rounded, color: Colors.grey.shade600, size: 18),
                                          SizedBox(width: 8),
                                          Text('Identity Verification Data', style: TextStyle(color: Colors.indigo.shade400, fontWeight: FontWeight.bold, fontSize: 12)),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Text('$relation of $sName', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
                                      SizedBox(height: 4),
                                      Text('Class: $sClass  •  Roll: $sRoll', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                              
                              SizedBox(height: 28),
                              
                              // Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => _updateStatus(context, docId, 'Rejected'),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xFFFEF2F2), // Very soft red
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      child: Text('Decline', style: TextStyle(color: Colors.red.shade500, fontWeight: FontWeight.w800, fontSize: 16)),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _updateStatus(context, docId, 'Approved'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade600, // Premium Emerald Green
                                        foregroundColor: Colors.white,
                                        elevation: 8,
                                        shadowColor: Colors.green.shade600.withValues(alpha: 0.5),
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      child: Text('Approve', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'teacher': return Color(0xFF4F46E5); // Indigo
      case 'student': return Colors.green.shade700; // Emerald
      case 'guardian': return Color(0xFF7C3AED); // Purple
      default: return Colors.grey.shade600; // Slate
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'teacher': return Icons.school_rounded;
      case 'student': return Icons.face_rounded;
      case 'guardian': return Icons.family_restroom_rounded;
      default: return Icons.person_rounded;
    }
  }
}

