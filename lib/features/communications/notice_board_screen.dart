import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import 'create_notice_screen.dart';

class NoticeBoardScreen extends StatelessWidget {
  final String role;
  const NoticeBoardScreen({super.key, this.role = 'Student'});

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Urgent':
        return Colors.red.shade500; // Red
      case 'Holiday':
        return Colors.green.shade600; // Emerald
      case 'Exam':
        return AppTheme.primaryBrand; // Purple
      case 'Event':
        return Colors.orange.shade500; // Amber
      case 'General':
      default:
        return Colors.blue.shade600; // Blue
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Urgent':
        return Icons.warning_rounded;
      case 'Holiday':
        return Icons.celebration_rounded;
      case 'Exam':
        return Icons.assignment_rounded;
      case 'Event':
        return Icons.event_rounded;
      case 'General':
      default:
        return Icons.campaign_rounded;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) return 'Today, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    if (difference.inDays == 1) return 'Yesterday';
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No notices found', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the array of targets to query. 
    // Everyone sees 'All'. Teachers also see 'Teacher', etc.
    List<String> allowedTargets = ['All'];
    if (role != 'Admin') {
      allowedTargets.add(role);
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Notice Board', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primaryBrand,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Fetch recent notices with a bounded limit to prevent Firestore 50k read quota exhaustion
        stream: FirebaseFirestore.instance.collection('notices').orderBy('createdAt', descending: true).limit(30).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong!\nEnsure Firestore Indexes are built if using complex queries.\nError: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade300),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          // Client-side filtering
          final allNotices = snapshot.data!.docs;
          final notices = role == 'Admin' 
              ? allNotices 
              : allNotices.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final target = data['target'] ?? 'All';
                  return allowedTargets.contains(target);
                }).toList();

          if (notices.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final notice = notices[index].data() as Map<String, dynamic>;
              
              final title = notice['title'] ?? 'No Title';
              final body = notice['body'] ?? '';
              final category = notice['category'] ?? 'General';
              final target = notice['target'] ?? 'All';
              final createdAt = notice['createdAt'] as Timestamp?;
              
              final dateObj = createdAt != null ? createdAt.toDate() : DateTime.now();
              final dateStr = createdAt != null ? _formatDate(dateObj) : 'Just now';
              
              final isNew = DateTime.now().difference(dateObj).inHours < 48; // Less than 48 hours old
              final color = _getCategoryColor(category);
              final icon = _getCategoryIcon(category);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 8))],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      _showNoticeDetails(context, title, body, dateStr, category, color, icon);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                                child: Icon(icon, color: color, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Text(dateStr, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold))),
                                        if (isNew)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(color: Colors.red.shade500, borderRadius: BorderRadius.circular(10)),
                                            child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary, height: 1.3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people_alt_rounded, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 6),
                                Text('To: $target', style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                                const SizedBox(width: 16),
                                Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.grey.shade500, shape: BoxShape.circle)),
                                const SizedBox(width: 16),
                                Text(category, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w800)),
                              ],
                            ),
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
      floatingActionButton: role == 'Admin'
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateNoticeScreen()));
              },
              backgroundColor: AppTheme.primaryBrand,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('New Notice', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              elevation: 4,
            )
          : null,
    );
  }

  void _showNoticeDetails(BuildContext context, String title, String body, String date, String category, Color color, IconData icon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              height: 5,
              width: 50,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                          child: Icon(icon, color: color, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(category.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
                              const SizedBox(height: 4),
                              Text(date, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primaryBrand, height: 1.3)),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 24),
                    Text(
                      body,
                      style: const TextStyle(fontSize: 16, color: Color(0xFF334155), height: 1.6, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

