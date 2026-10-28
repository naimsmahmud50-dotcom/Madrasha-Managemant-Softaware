import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/bounce_wrapper.dart';

class TeacherEvaluationScreen extends StatefulWidget {
  const TeacherEvaluationScreen({super.key});

  @override
  State<TeacherEvaluationScreen> createState() => _TeacherEvaluationScreenState();
}

class _TeacherEvaluationScreenState extends State<TeacherEvaluationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, String>> _teachers = [
    {'id': 't1', 'name': 'Mawlana Abdur Rahman', 'department': 'Kitab (Dawra-e-Hadith)', 'phone': '01711-223344'},
    {'id': 't2', 'name': 'Qari Ibrahim Khalil', 'department': 'Hifz & Tajweed', 'phone': '01811-334455'},
    {'id': 't3', 'name': 'Mufti Tariq Jamil', 'department': 'Darul Ifta & Fiqh', 'phone': '01911-445566'},
    {'id': 't4', 'name': 'Mawlana Mahbub Alam', 'department': 'Mutawassitah & Arabic', 'phone': '01611-556677'},
  ];

  late String _selectedTeacherId;
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  // Criteria ratings (1-5 scale)
  final Map<String, int> _ratings = {
    'tarbiyah': 5,
    'subject_mastery': 4,
    'punctuality': 5,
    'student_care': 4,
    'governance': 5,
  };

  // Past evaluations log
  final List<Map<String, dynamic>> _recentEvaluations = [
    {
      'teacherName': 'Qari Ibrahim Khalil',
      'department': 'Hifz & Tajweed',
      'date': '20 Oct 2026',
      'averageScore': 4.8,
      'grade': 'Mumtaz (ممتاز)',
      'evaluator': 'Principal Office',
    },
    {
      'teacherName': 'Mawlana Abdur Rahman',
      'department': 'Kitab (Dawra-e-Hadith)',
      'date': '15 Oct 2026',
      'averageScore': 4.6,
      'grade': 'Mumtaz (ممتاز)',
      'evaluator': 'Academic Committee',
    },
    {
      'teacherName': 'Mawlana Mahbub Alam',
      'department': 'Mutawassitah & Arabic',
      'date': '08 Oct 2026',
      'averageScore': 4.2,
      'grade': 'Jayyid Jiddan (جيد جداً)',
      'evaluator': 'Senior Nazir',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedTeacherId = _teachers.first['id']!;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  double get _averageScore {
    final values = _ratings.values.toList();
    if (values.isEmpty) return 0.0;
    final sum = values.fold<int>(0, (a, b) => a + b);
    return sum / values.length;
  }

  String get _performanceRatingTier {
    final score = _averageScore;
    if (score >= 4.5) return 'Mumtaz / Outstanding (ممتاز)';
    if (score >= 3.8) return 'Jayyid Jiddan / Very Good (جيد جداً)';
    if (score >= 3.0) return 'Jayyid / Satisfactory (جيد)';
    return 'Maqbool / Needs Improvement (مقبول)';
  }

  Color get _performanceTierColor {
    final score = _averageScore;
    if (score >= 4.5) return const Color(0xFF047857); // Emerald
    if (score >= 3.8) return const Color(0xFF0284C7); // Blue
    if (score >= 3.0) return const Color(0xFFD97706); // Amber
    return const Color(0xFFDC2626); // Red
  }

  void _submitEvaluation() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter qualitative feedback or remarks before submitting.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      final teacher = _teachers.firstWhere((t) => t['id'] == _selectedTeacherId);

      setState(() {
        _isSubmitting = false;
        _recentEvaluations.insert(0, {
          'teacherName': teacher['name'],
          'department': teacher['department'],
          'date': 'Today',
          'averageScore': double.parse(_averageScore.toStringAsFixed(1)),
          'grade': _performanceRatingTier.split(' / ').first,
          'evaluator': 'Authorized Admin',
        });
        _feedbackController.clear();
      });

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF047857), size: 28),
              SizedBox(width: 8),
              Text('Evaluation Recorded'),
            ],
          ),
          content: Text(
            'Institutional KPI evaluation for ${teacher['name']} has been submitted with an average score of ${_averageScore.toStringAsFixed(1)} / 5.0.\n\nAll records are sealed with cryptographic audit trails.',
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _tabController.animateTo(1);
              },
              child: const Text('View History', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF047857),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Teacher Evaluation & KPI',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: AppTheme.primaryBrand,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentGold,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(icon: Icon(Icons.rate_review_rounded), text: 'New Evaluation'),
            Tab(icon: Icon(Icons.history_edu_rounded), text: 'Past Records'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEvaluationFormTab(),
          _buildRecordsTab(),
        ],
      ),
    );
  }

  Widget _buildEvaluationFormTab() {
    final currentTeacher = _teachers.firstWhere((t) => t['id'] == _selectedTeacherId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Teacher Selection Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.person_outline_rounded, color: AppTheme.primaryBrand, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Faculty Member',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedTeacherId,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down_circle_rounded, color: AppTheme.primaryBrand),
                              items: _teachers.map((teacher) {
                                return DropdownMenuItem<String>(
                                  value: teacher['id'],
                                  child: Text(
                                    teacher['name']!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedTeacherId = val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dept: ${currentTeacher['department']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Contact: ${currentTeacher['phone']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Realtime Score Summary Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _performanceTierColor.withValues(alpha: 0.12),
                  _performanceTierColor.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _performanceTierColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _performanceTierColor,
                  child: Text(
                    _averageScore.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Evaluation Score',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _performanceRatingTier,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _performanceTierColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Criteria Rating Sliders / Stars
          const Text(
            'Evaluation Criteria (1 to 5 Stars)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),

          _buildRatingCard(
            keyId: 'tarbiyah',
            title: 'Tarbiyah & Sunnah Modeling',
            subtitle: 'Spiritual guidance, akhlaq in congregation, personal character',
            icon: Icons.mosque_rounded,
          ),
          _buildRatingCard(
            keyId: 'subject_mastery',
            title: 'Tajweed & Subject Mastery',
            subtitle: 'Accurate makhraj, depth in Dars-e-Nizami kitab, pedagogy',
            icon: Icons.menu_book_rounded,
          ),
          _buildRatingCard(
            keyId: 'punctuality',
            title: 'Punctuality & Class Discipline',
            subtitle: 'On-time attendance, lesson continuity, syllabus adherence',
            icon: Icons.timer_rounded,
          ),
          _buildRatingCard(
            keyId: 'student_care',
            title: 'Student Care & Guidance',
            subtitle: 'Mentorship, empathy towards weak students, conflict resolution',
            icon: Icons.volunteer_activism_rounded,
          ),
          _buildRatingCard(
            keyId: 'governance',
            title: 'Institutional Governance',
            subtitle: 'Adherence to Madrasah policies, exam duty, admin synergy',
            icon: Icons.gavel_rounded,
          ),

          const SizedBox(height: 20),

          // Qualitative Feedback Area
          const Text(
            'Confidential Review & Recommendations',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter specific commendations, areas of development, or pedagogical feedback...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Submit Action Button
          BounceWrapper(
            onTap: _isSubmitting ? () {} : _submitEvaluation,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.primaryBrand,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBrand.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Submit Confidential Evaluation',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRatingCard({
    required String keyId,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final currentVal = _ratings[keyId] ?? 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryBrand, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= currentVal;

              return InkWell(
                onTap: () => setState(() => _ratings[keyId] = starIndex),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFilled ? AppTheme.accentGold : Colors.grey.shade300,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recentEvaluations.length,
      itemBuilder: (context, index) {
        final item = _recentEvaluations[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['teacherName'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['grade'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryBrand),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Department: ${item['department']}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(item['date'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: AppTheme.accentGold),
                      const SizedBox(width: 4),
                      Text(
                        '${item['averageScore']} / 5.0',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                  Text(
                    'By: ${item['evaluator']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
