import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/madrasah_settings_provider.dart';
import '../hifz/hifz_screen.dart';
import '../academic/live_class_screen.dart';
import '../academic/lms_screen.dart';
import '../academic/assignment_screen.dart';
import '../academic/syllabus_screen.dart';
import '../academic/lesson_plan_screen.dart';
import '../routine/routine_screen.dart';
import '../attendance/attendance_screen.dart';
import '../academic/exam_routine_screen.dart';
import '../result/result_screen.dart';
import '../academic/certificate_screen.dart';
import '../academic/fatwa_screen.dart';
import '../academic/disciplinary_screen.dart';
import '../academic/career_placement_screen.dart';
import '../academic/board_registration_screen.dart';
import '../academic/nctb_assignment_screen.dart';
import '../finance/stipend_management_screen.dart';
import '../people/mpo_tracking_screen.dart';
import '../finance/fees_screen.dart';
import '../finance/payroll_screen.dart';
import '../finance/expense_tracking_screen.dart';
import '../finance/donation_screen.dart';
import '../people/staff_attendance_screen.dart';
import '../academic/leave_screen.dart';
import '../academic/teacher_evaluation_screen.dart';
import '../people/committee_screen.dart';
import '../operations/admission_screen.dart';
import '../operations/inventory_screen.dart';
import '../operations/library_admin_screen.dart';
import '../operations/task_management_screen.dart';
import '../communications/notice_board_screen.dart';
import '../communications/messaging_screen.dart';
import '../communications/ptm_screen.dart';
import '../security/gate_pass_screen.dart';
import '../security/visitor_log_screen.dart';
import '../transport/transport_tracking_screen.dart';
import '../operations/bell_management_screen.dart';
import '../hostel/hostel_screen.dart';
import '../hostel/matbakh_screen.dart';
import '../hostel/infirmary_screen.dart';
import '../settings/module_manager_screen.dart';
import '../setup/onboarding_screen.dart';
import '../people/alumni_network_screen.dart';

class BounceWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const BounceWrapper({super.key, required this.child, required this.onTap});

  @override
  State<BounceWrapper> createState() => _BounceWrapperState();
}

class _BounceWrapperState extends State<BounceWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: widget.child,
      ),
    );
  }
}

class AppMenuScreen extends ConsumerWidget {
  final String role;
  const AppMenuScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final madrasahType = ref.watch(madrasahTypeProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Menu & Features',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryBrand,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCategoryGroup(
            context,
            'Academic & Learning',
            Icons.school_rounded,
            Colors.blue.shade700,
            [
              if (role != 'Guardian')
                _MenuRoute(
                  'Live Class',
                  Icons.video_camera_front_rounded,
                  LiveClassScreen(role: role),
                ),
              if (role != 'Guardian')
                _MenuRoute(
                  'LMS & Content',
                  Icons.play_lesson_rounded,
                  LmsScreen(role: role),
                ),
              if (role != 'Guardian')
                _MenuRoute(
                  role == 'Teacher' || role == 'Admin'
                      ? 'Manage Assignments'
                      : 'Assignments',
                  Icons.assignment_rounded,
                  AssignmentScreen(role: role),
                ),
              _MenuRoute(
                'Syllabus',
                Icons.menu_book_rounded,
                SyllabusScreen(),
              ),
              if (role == 'Teacher' || role == 'Admin')
                _MenuRoute(
                  'Lesson Plan',
                  Icons.edit_note_rounded,
                  LessonPlanScreen(),
                ),
              _MenuRoute(
                'Class Routine',
                Icons.calendar_month_rounded,
                RoutineScreen(role: role),
              ),
              _MenuRoute(
                'Attendance',
                Icons.how_to_reg_rounded,
                AttendanceScreen(role: role),
              ),
              if (role != 'Admin')
                _MenuRoute(
                  'Leave Applications',
                  Icons.event_busy_rounded,
                  LeaveScreen(role: role),
                ),
            ],
          ),

          _buildCategoryGroup(
            context,
            'Exams & Results',
            Icons.grading_rounded,
            AppTheme.primaryBrand,
            [
              _MenuRoute(
                'Exam Routine',
                Icons.event_note_rounded,
                ExamRoutineScreen(role: role),
              ),
              _MenuRoute(
                'Results & Marksheet',
                Icons.score_rounded,
                ResultScreen(role: role),
              ),
              if (role != 'Teacher')
                _MenuRoute(
                  'Certificates',
                  Icons.workspace_premium_rounded,
                  CertificateScreen(),
                ),
            ],
          ),

          _buildCategoryGroup(
            context,
            (role == 'Admin' || role == 'Teacher')
                ? 'Finance & Accounts'
                : 'Fees & Payments',
            Icons.account_balance_wallet_rounded,
            Colors.green.shade600,
            [
              _MenuRoute(
                (role == 'Admin' || role == 'Teacher')
                    ? 'Fee Collection'
                    : 'My Fees',
                Icons.payments_rounded,
                FeesScreen(role: role),
              ),
              if (role == 'Admin')
                _MenuRoute(
                  'Payroll (Salary)',
                  Icons.account_balance_rounded,
                  PayrollScreen(role: role),
                ),
              if (role == 'Admin')
                _MenuRoute(
                  'Expense Tracking',
                  Icons.receipt_long_rounded,
                  ExpenseTrackingScreen(),
                ),
              if (role == 'Admin')
                _MenuRoute(
                  'Donor Management',
                  Icons.volunteer_activism_rounded,
                  DonationScreen(),
                ),
            ],
          ),

          if (role == 'Admin')
            _buildCategoryGroup(
              context,
              'HR & Staff Management',
              Icons.groups_rounded,
              Colors.orange.shade500,
              [
                _MenuRoute(
                  'Staff Attendance',
                  Icons.fingerprint_rounded,
                  StaffAttendanceScreen(role: role),
                ),
                _MenuRoute(
                  'Leave Management',
                  Icons.event_busy_rounded,
                  LeaveScreen(role: role),
                ),

                _MenuRoute(
                  'Teacher Evaluation',
                  Icons.star_rate_rounded,
                  TeacherEvaluationScreen(),
                ),
                _MenuRoute(
                  'Committee/Majlis',
                  Icons.account_balance_rounded,
                  CommitteeBoardScreen(),
                ),
              ],
            ),

          if (role == 'Admin')
            _buildCategoryGroup(
              context,
              'Administration',
              Icons.admin_panel_settings_rounded,
              Colors.red.shade500,
              [
                _MenuRoute(
                  'Admission Desk',
                  Icons.how_to_reg_rounded,
                  AdmissionScreen(),
                ),
                _MenuRoute(
                  'Inventory & Assets',
                  Icons.inventory_2_rounded,
                  InventoryScreen(),
                ),
                _MenuRoute(
                  'Library Admin',
                  Icons.local_library_rounded,
                  LibraryAdminScreen(),
                ),
                _MenuRoute(
                  'Task Management',
                  Icons.task_alt_rounded,
                  TaskManagementScreen(),
                ),
              ],
            ),

          _buildCategoryGroup(
            context,
            'Communication',
            Icons.forum_rounded,
            Color(0xFF0EA5E9),
            [
              _MenuRoute(
                'Notice Board',
                Icons.campaign_rounded,
                NoticeBoardScreen(role: role),
              ),
              if (role == 'Admin' || role == 'Teacher')
                _MenuRoute(
                  'SMS Gateway',
                  Icons.sms_rounded,
                  MessagingScreen(role: role),
                ),
              if (role == 'Admin' || role == 'Teacher')
                _MenuRoute(
                  'Parent Meeting',
                  Icons.people_alt_rounded,
                  PtmScreen(),
                ),
              _MenuRoute(
                'Messages',
                Icons.chat_rounded,
                MessagingScreen(role: role),
              ),
              _MenuRoute(
                'Alumni Network',
                Icons.diversity_3_rounded,
                AlumniNetworkScreen(),
              ),
            ],
          ),

          _buildCategoryGroup(
            context,
            'Campus & Security',
            Icons.security_rounded,
            Colors.grey.shade600,
            [
              if (role != 'Teacher')
                _MenuRoute(
                  'Gate Pass',
                  Icons.badge_rounded,
                  GatePassScreen(),
                ),
              if (role == 'Admin')
                _MenuRoute(
                  'Visitor Log',
                  Icons.recent_actors_rounded,
                  VisitorLogScreen(),
                ),
              _MenuRoute(
                'Transport Tracking',
                Icons.directions_bus_rounded,
                TransportTrackingScreen(),
              ),
              if (role == 'Admin')
                _MenuRoute(
                  'Bell Management',
                  Icons.notifications_active_rounded,
                  BellManagementScreen(),
                ),
            ],
          ),

          if (role != 'Teacher')
            _buildCategoryGroup(
              context,
              'Hostel & Boarding',
              Icons.hotel_rounded,
              Colors.orange.shade600,
              [
                _MenuRoute(
                  'Hostel/Dormitory',
                  Icons.hotel_rounded,
                  HostelScreen(role: role),
                ),
                _MenuRoute(
                  'Matbakh (Dining)',
                  Icons.restaurant_rounded,
                  MatbakhScreen(role: role),
                ),
                _MenuRoute(
                  'Infirmary (Medical)',
                  Icons.local_hospital_rounded,
                  InfirmaryScreen(),
                ),
              ],
            ),

          if (madrasahType == MadrasahType.both ||
              madrasahType == MadrasahType.qawmi)
            _buildCategoryGroup(
              context,
              'Qawmi Specific',
              Icons.menu_book_rounded,
              AppTheme.primaryBrand,
              [
                _MenuRoute(
                  'Hifz Tracker',
                  Icons.chrome_reader_mode_rounded,
                  HifzTrackingScreen(role: role),
                ),
                if (role != 'Guardian')
                  _MenuRoute(
                    'Darul Ifta (Fatwa)',
                    Icons.help_outline_rounded,
                    FatwaScreen(),
                  ),
                _MenuRoute(
                  'Tarbiyah (Akhlaq)',
                  Icons.gavel_rounded,
                  DisciplinaryScreen(),
                ),
                if (role == 'Admin' || role == 'Student')
                  _MenuRoute(
                    'Fuzalaa (Careers)',
                    Icons.work_history_rounded,
                    CareerPlacementScreen(),
                  ),
              ],
            ),

          if (madrasahType == MadrasahType.both ||
              madrasahType == MadrasahType.alia)
            _buildCategoryGroup(
              context,
              'Alia Specific',
              Icons.account_balance_rounded,
              Color(0xFF0284C7),
              [
                if (role == 'Admin')
                  _MenuRoute(
                    'Board Registration',
                    Icons.app_registration_rounded,
                    BoardRegistrationScreen(),
                  ),
                _MenuRoute(
                  'NCTB Assignments',
                  Icons.assignment_turned_in_rounded,
                  NctbAssignmentScreen(),
                ),
                if (role != 'Teacher')
                  _MenuRoute(
                    'Govt. Stipend',
                    Icons.account_balance_wallet_rounded,
                    StipendManagementScreen(),
                  ),
                if (role == 'Admin' || role == 'Teacher')
                  _MenuRoute(
                    'MPO Tracking',
                    Icons.model_training_rounded,
                    MpoTrackingScreen(),
                  ),
              ],
            ),

          if (role == 'Admin')
            _buildCategoryGroup(
              context,
              'System Setup',
              Icons.settings_rounded,
              AppTheme.primaryBrand,
              [
                _MenuRoute(
                  'Module Manager',
                  Icons.extension_rounded,
                  ModuleManagerScreen(),
                ),
                _MenuRoute(
                  'Onboarding Setup',
                  Icons.rocket_launch_rounded,
                  OnboardingScreen(),
                ),
              ],
            ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCategoryGroup(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<_MenuRoute> routes,
  ) {
    if (routes.isEmpty) return SizedBox.shrink(); // Hide if empty

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),)
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          GridView.builder(
            padding: EdgeInsets.all(16),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              return BounceWrapper(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => route.screen),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(
                        route.icon,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      route.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuRoute {
  final String title;
  final IconData icon;
  final Widget screen;
  _MenuRoute(this.title, this.icon, this.screen);
}

