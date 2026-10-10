import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaveScreen extends StatefulWidget {
  final String role;
  const LeaveScreen({super.key, required this.role});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final List<String> _leaveTypes = ['Sick Leave', 'Casual Leave', 'Emergency'];
  String _selectedType = 'Sick Leave';

  void _showApplyLeaveSheet() {
    String applicantName = '';
    String reason = '';
    String days = '1';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24, right: 24, top: 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(height: 24),
                    Text('Apply for Leave', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                    const SizedBox(height: 16),
                    
                    TextField(
                      decoration: const InputDecoration(labelText: 'Applicant Name', border: OutlineInputBorder()),
                      onChanged: (val) => applicantName = val,
                    ),
                    const SizedBox(height: 12),
                    
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(labelText: 'Leave Type', border: OutlineInputBorder()),
                      items: _leaveTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setSheetState(() => _selectedType = val!),
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Number of Days', border: OutlineInputBorder()),
                      onChanged: (val) => days = val,
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
                      onChanged: (val) => reason = val,
                    ),
                    
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBrand,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (applicantName.isEmpty || reason.isEmpty || days.isEmpty) return;

                          final uid = FirebaseAuth.instance.currentUser?.uid;

                          await FirebaseFirestore.instance.collection('leaves').add({
                            'applicantName': applicantName,
                            'role': widget.role,
                            'uid': uid, // Track who applied
                            'type': _selectedType,
                            'days': days,
                            'reason': reason,
                            'status': 'Pending',
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('Submit Application', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _updateStatus(String docId, String newStatus) {
    FirebaseFirestore.instance.collection('leaves').doc(docId).update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'Admin';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(isAdmin ? 'Leave Management' : 'My Leave Applications', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primaryBrand,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('leaves').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final allDocs = snapshot.data!.docs;
          final currentUid = FirebaseAuth.instance.currentUser?.uid;
          
          // Client-side filtering to avoid Composite Index requirements
          final filteredDocs = isAdmin 
              ? allDocs 
              : allDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  // Fallback to old role check if uid is null (legacy data)
                  if (data['uid'] != null) {
                    return data['uid'] == currentUid;
                  }
                  // Backward compatibility for old test data
                  return data['role'] == widget.role; 
                }).toList();

          if (filteredDocs.isEmpty) {
            return _buildEmptyState();
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final doc = filteredDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildLeaveCard(doc.id, data, isAdmin);
            },
          );
        },
      ),
      floatingActionButton: !isAdmin
          ? FloatingActionButton.extended(
              onPressed: _showApplyLeaveSheet,
              backgroundColor: AppTheme.primaryBrand,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('Apply Leave', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No leave applications found', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLeaveCard(String docId, Map<String, dynamic> data, bool isAdmin) {
    final applicantName = data['applicantName'] ?? 'Unknown';
    final role = data['role'] ?? 'Student';
    final type = data['type'] ?? 'Leave';
    final days = data['days'] ?? '1';
    final reason = data['reason'] ?? '';
    final status = data['status'] ?? 'Pending';
    
    Color statusColor;
    Color statusBg;
    IconData statusIcon;

    if (status == 'Approved') {
      statusColor = const Color(0xFF16A34A);
      statusBg = const Color(0xFFDCFCE7);
      statusIcon = Icons.check_circle_rounded;
    } else if (status == 'Rejected') {
      statusColor = const Color(0xFFDC2626);
      statusBg = const Color(0xFFFEE2E2);
      statusIcon = Icons.cancel_rounded;
    } else {
      statusColor = Colors.orange.shade600;
      statusBg = Colors.orange.shade50;
      statusIcon = Icons.pending_actions_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      child: Icon(Icons.person_outline_rounded, color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(applicantName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBrand)),
                        Text(role, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildInfoBadge(Icons.calendar_month_rounded, '$days Days'),
                    const SizedBox(width: 12),
                    _buildInfoBadge(Icons.category_rounded, type),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Reason', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(reason, style: const TextStyle(color: Color(0xFF334155), height: 1.4)),
              ],
            ),
          ),

          // Admin Controls
          if (isAdmin && status == 'Pending')
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626), side: const BorderSide(color: Color(0xFFDC2626)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _updateStatus(docId, 'Rejected'),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _updateStatus(docId, 'Approved'),
                      child: const Text('Approve', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
        ],
      ),
    );
  }
}

