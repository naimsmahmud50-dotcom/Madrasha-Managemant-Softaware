import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/bounce_wrapper.dart';
import '../../core/utils/pdf_generator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/madrasah_settings_provider.dart';
import '../../core/utils/grading_engine.dart';

class MarksheetScreen extends ConsumerWidget {
  final String role;
  
  const MarksheetScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final madrasahType = ref.watch(madrasahTypeProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Slate 100
      appBar: AppBar(
        title: const Text('Academic Results', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.primaryBrand, // Slate 900
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('exam_results').orderBy('createdAt', descending: true).limit(50).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return _buildResultCard(context, data, madrasahType);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_late_rounded, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text('No Results Published Yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Your exam results will appear here.', style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, Map<String, dynamic> data, MadrasahType type) {
    final double mark = (data['mark'] ?? 0).toDouble();
    final String grade = GradingEngine.getGrade(mark, type);
    final double gpa = GradingEngine.getGpa(mark, type);
    final Color gradeColor = GradingEngine.getGradeColor(grade);
    
    // Determine pass/fail based on grading engine (Rasib or F)
    final bool isPass = grade != 'Rasib' && grade != 'F';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data['examName'] ?? 'Examination',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBrand),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPass ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isPass ? 'PASSED' : 'FAILED',
                    style: TextStyle(color: isPass ? Colors.green.shade700 : Colors.red.shade700, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Student Name', data['studentName'] ?? 'Unknown'),
            const SizedBox(height: 8),
            _buildInfoRow('Class / Jamaat', data['className'] ?? 'Unknown'),
            const SizedBox(height: 8),
            _buildInfoRow('Subject', data['subject'] ?? 'Unknown'),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Marks', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(mark.toStringAsFixed(0), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppTheme.primaryBrand)),
                  ],
                ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Grade', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      type == MadrasahType.qawmi ? grade : '$grade (GPA: ${gpa.toStringAsFixed(2)})', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: gradeColor)
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            BounceWrapper(
              onTap: () {
                PdfGenerator.generateAndPrintMarksheet(
                  studentName: data['studentName'] ?? 'Unknown',
                  studentRoll: data['studentRoll'] ?? '00',
                  className: data['className'] ?? 'Unknown Class',
                  examName: data['examName'] ?? 'Examination',
                  subjects: { data['subject'] ?? 'Subject': { 'marks': mark, 'grade': grade } },
                  totalScore: mark.toStringAsFixed(0),
                  grade: isPass ? 'PASSED' : 'FAILED',
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf_rounded, color: AppTheme.primaryBrand, size: 20),
                    SizedBox(width: 8),
                    Text('Download PDF Marksheet', style: TextStyle(color: AppTheme.primaryBrand, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value, 
            textAlign: TextAlign.right,
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}


