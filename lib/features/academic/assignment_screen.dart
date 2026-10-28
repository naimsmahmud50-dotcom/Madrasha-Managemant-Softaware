import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/widgets/bounce_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssignmentScreen extends StatefulWidget {
  final String role;
  const AssignmentScreen({super.key, required this.role});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddAssignmentSheet() {
    String subject = '';
    String title = '';
    String dueDate = '';
    String teacher = FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? 'Admin/Teacher';

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
                    Text('Post New Assignment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                    const SizedBox(height: 16),
                    
                    TextField(
                      decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
                      onChanged: (val) => subject = val,
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      decoration: const InputDecoration(labelText: 'Assignment Title / Topic', border: OutlineInputBorder()),
                      onChanged: (val) => title = val,
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      decoration: const InputDecoration(labelText: 'Due Date (e.g., 25 Sept 2026)', border: OutlineInputBorder()),
                      onChanged: (val) => dueDate = val,
                    ),
                    
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDB2777),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (subject.isEmpty || title.isEmpty || dueDate.isEmpty) return;

                          await FirebaseFirestore.instance.collection('assignments').add({
                            'subject': subject,
                            'title': title,
                            'dueDate': dueDate,
                            'teacher': teacher,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('Post Assignment', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    final bool canAdd = widget.role == 'Admin' || widget.role == 'Teacher';

    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8), // Pink 50
      appBar: AppBar(
        title: const Text('Assignments & Homework', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFFDB2777), // Pink 600
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'PENDING / ALL'),
            Tab(text: 'SUBMITTED (Mock)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAssignmentStream(canAdd),
          _buildSubmittedTab(),
        ],
      ),
      floatingActionButton: canAdd
          ? FloatingActionButton.extended(
              onPressed: _showAddAssignmentSheet,
              backgroundColor: const Color(0xFFDB2777),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('Post Assignment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildAssignmentStream(bool canAdd) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('assignments').orderBy('createdAt', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFDB2777)));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No assignments posted yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildAssignmentCard(
              docId: doc.id,
              subject: data['subject'] ?? 'Unknown',
              title: data['title'] ?? 'No Title',
              dueDate: data['dueDate'] ?? 'No Date',
              teacher: data['teacher'] ?? 'Unknown',
              isUrgent: false, 
              canDelete: canAdd,
            );
          },
        );
      },
    );
  }

  Widget _buildSubmittedTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAssignmentCard(
          docId: 'mock1',
          subject: 'Hadith Studies',
          title: 'Write 40 Short Hadiths with Translation',
          dueDate: '15 Sept 2026',
          teacher: 'Ustad Uthman',
          isUrgent: false,
          isSubmitted: true,
          grade: '10/10 (Excellent)',
          canDelete: false,
        ),
        _buildAssignmentCard(
          docId: 'mock2',
          subject: 'English',
          title: 'Essay on Prophet\'s (PBUH) Character',
          dueDate: '10 Sept 2026',
          teacher: 'Sir Tariq',
          isUrgent: false,
          isSubmitted: true,
          grade: '8.5/10',
          canDelete: false,
        ),
      ],
    );
  }

  Widget _buildAssignmentCard({
    required String docId,
    required String subject,
    required String title,
    required String dueDate,
    required String teacher,
    required bool isUrgent,
    bool isSubmitted = false,
    String? grade,
    required bool canDelete,
  }) {
    return BounceWrapper(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isUrgent ? Color(0xFFFCA5A5) : Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSubmitted ? Colors.green.shade50 : (isUrgent ? Color(0xFFFEF2F2) : Colors.grey.shade50),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      subject,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isSubmitted ? const Color(0xFF166534) : (isUrgent ? const Color(0xFF991B1B) : const Color(0xFF475569)),
                      ),
                    ),
                  ),
                  if (canDelete && !isSubmitted)
                    GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance.collection('assignments').doc(docId).delete();
                      },
                      child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                    ),
                  if (isUrgent)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red.shade500, borderRadius: BorderRadius.circular(12)),
                      child: const Text('Urgent', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  if (isSubmitted)
                    Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(teacher, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 16, color: isUrgent ? Colors.red.shade500 : Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text('Due: $dueDate', style: TextStyle(fontSize: 13, color: isUrgent ? Colors.red.shade500 : Colors.grey.shade600, fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                  if (isSubmitted && grade != null) ...[
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                    Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, size: 18, color: Colors.orange.shade500),
                        const SizedBox(width: 8),
                        Text('Grade: $grade', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      ],
                    ),
                  ],
                  if (!isSubmitted && widget.role == 'Student') ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assignment marked as submitted (Mock)')));
                        },
                        icon: const Icon(Icons.upload_file_rounded, size: 18, color: Colors.white),
                        label: const Text('Submit Assignment', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDB2777),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

