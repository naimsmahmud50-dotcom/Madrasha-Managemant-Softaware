import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class TeacherAssignmentScreen extends StatefulWidget {
  const TeacherAssignmentScreen({super.key});

  @override
  State<TeacherAssignmentScreen> createState() => _TeacherAssignmentScreenState();
}

class _TeacherAssignmentScreenState extends State<TeacherAssignmentScreen> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8), // Pink 50
      appBar: AppBar(
        title: const Text('Manage Assignments', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFFBE185D), // Pink 700 (Distinct from Student's Pink 600)
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'ACTIVE (ASSIGNED)'),
            Tab(text: 'NEEDS GRADING'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTab(),
          _buildGradingTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Assignment Creator...')));
        },
        backgroundColor: const Color(0xFFBE185D),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Assignment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildActiveTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTeacherCard(
          subject: 'Arabic Grammar (Nahw)',
          className: 'Class 8 (Mutawassitah) - Sec A',
          title: 'Memorize Chapter 3 Rules & Solve Exercise',
          dueDate: 'Tomorrow, 10:00 AM',
          stats: '25/30 Submitted',
          isUrgent: true,
        ),
        _buildTeacherCard(
          subject: 'Arabic Grammar (Nahw)',
          className: 'Class 8 (Mutawassitah) - Sec B',
          title: 'Translate sentences 1-20',
          dueDate: '25 Sept 2026',
          stats: '5/28 Submitted',
          isUrgent: false,
        ),
      ],
    );
  }

  Widget _buildGradingTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTeacherCard(
          subject: 'Islamic History',
          className: 'Class 7 (Ibtidaiyyah)',
          title: 'Essay on the Battle of Badr',
          dueDate: '15 Sept 2026',
          stats: '30/30 Submitted • 12 Ungraded',
          isUrgent: false,
          needsGrading: true,
        ),
      ],
    );
  }

  Widget _buildTeacherCard({
    required String subject,
    required String className,
    required String title,
    required String dueDate,
    required String stats,
    required bool isUrgent,
    bool needsGrading = false,
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
                color: needsGrading ? Color(0xFFFFFBEB) : (isUrgent ? Color(0xFFFEF2F2) : Colors.grey.shade50),
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
                        color: needsGrading ? const Color(0xFFB45309) : (isUrgent ? const Color(0xFF991B1B) : const Color(0xFF475569)),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (needsGrading)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange.shade500, borderRadius: BorderRadius.circular(12)),
                      child: const Text('Review Required', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
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
                      Icon(Icons.group_outlined, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(className, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 16, color: isUrgent ? Colors.red.shade500 : Colors.grey.shade500),
                          const SizedBox(width: 6),
                          Text('Due: $dueDate', style: TextStyle(fontSize: 13, color: isUrgent ? Colors.red.shade500 : Colors.grey.shade600)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          stats, 
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(needsGrading ? Icons.grading_rounded : Icons.visibility_rounded, size: 18),
                      label: Text(needsGrading ? 'Grade Submissions' : 'View Submissions'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFBE185D),
                        side: const BorderSide(color: Color(0xFFBE185D)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

