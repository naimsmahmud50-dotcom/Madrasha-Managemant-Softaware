import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/madrasah_settings_provider.dart';
import '../../core/utils/grading_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/pdf_generator.dart';
import '../../core/theme/app_theme.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final String role;
  ResultScreen({super.key, required this.role});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final List<String> _classes = ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  String _selectedClass = 'Class 8';

  

  void _showAddResultSheet() {
    final madrasahType = ref.read(madrasahTypeProvider);
    String studentName = '';
    String term = 'Half-Yearly Exam';
    String quranMarks = '';
    String arabicMarks = '';
    String mathMarks = '';

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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                    SizedBox(height: 24),
                    Text('Publish Result', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    SizedBox(height: 16),
                    
                    DropdownButtonFormField<String>(
                      initialValue: term,
                      decoration: InputDecoration(labelText: 'Exam Term', border: OutlineInputBorder()),
                      items: ['1st Term Exam', 'Half-Yearly Exam', 'Annual Exam'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setSheetState(() => term = val!),
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      decoration: InputDecoration(labelText: 'Student Name', border: OutlineInputBorder()),
                      onChanged: (val) => studentName = val,
                    ),
                    SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Quran Marks', border: OutlineInputBorder()),
                            onChanged: (val) => quranMarks = val,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Arabic Marks', border: OutlineInputBorder()),
                            onChanged: (val) => arabicMarks = val,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Math Marks', border: OutlineInputBorder()),
                      onChanged: (val) => mathMarks = val,
                    ),
                    
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBrand,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (studentName.isEmpty || quranMarks.isEmpty || arabicMarks.isEmpty || mathMarks.isEmpty) return;
                          
                          int qM = int.tryParse(quranMarks) ?? 0;
                          int aM = int.tryParse(arabicMarks) ?? 0;
                          int mM = int.tryParse(mathMarks) ?? 0;
                          
                          int total = qM + aM + mM;
                          double avgGpa = (GradingEngine.getGpa(qM.toDouble(), madrasahType) + GradingEngine.getGpa(aM.toDouble(), madrasahType) + GradingEngine.getGpa(mM.toDouble(), madrasahType)) / 3.0;
                          double avgMarks = total / 3.0;
                          String finalGrade = madrasahType == MadrasahType.qawmi 
                              ? GradingEngine.getGrade(avgMarks, madrasahType) 
                              : GradingEngine.getGrade(avgGpa >= 5.0 ? 80 : (avgGpa >= 4.0 ? 70 : (avgGpa >= 3.5 ? 60 : (avgGpa >= 3.0 ? 50 : (avgGpa >= 2.0 ? 40 : (avgGpa >= 1.0 ? 33 : 0))))), madrasahType);

                          await FirebaseFirestore.instance.collection('results').add({
                            'sClass': _selectedClass,
                            'term': term,
                            'studentName': studentName,
                            'totalMarks': total,
                            'gpa': avgGpa.toStringAsFixed(2),
                            'grade': finalGrade,
                            'subjects': {
                              'Quran & Tajweed': {'marks': qM, 'grade': GradingEngine.getGrade(qM.toDouble(), madrasahType)},
                              'Arabic Grammar': {'marks': aM, 'grade': GradingEngine.getGrade(aM.toDouble(), madrasahType)},
                              'Mathematics': {'marks': mM, 'grade': GradingEngine.getGrade(mM.toDouble(), madrasahType)},
                            },
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text('Publish Marksheet', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 24),
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
    final isAdminOrTeacher = widget.role == 'Admin' || widget.role == 'Teacher';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(isAdminOrTeacher ? 'Manage Results' : 'My Marksheet', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primaryBrand, // Purple Brand for Exams
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Class Filter Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBrand,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedClass,
                  isExpanded: true,
                  dropdownColor: AppTheme.primaryBrand,
                  icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => _selectedClass = val!),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('results')
                  .where('sClass', isEqualTo: _selectedClass)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand));
                }
                
                if (snapshot.hasError) {
                  // Fallback for missing index error
                  if (snapshot.error.toString().contains('index')) {
                    return _buildWithoutIndexFallback();
                  }
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                final docs = snapshot.data!.docs;
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildMarksheetCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdminOrTeacher
          ? FloatingActionButton.extended(
              onPressed: _showAddResultSheet,
              backgroundColor: AppTheme.primaryBrand,
              icon: Icon(Icons.add_chart_rounded, color: Colors.white),
              label: Text('Publish Result', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }
  
  // Fallback stream if composite index is missing (filters purely in client)
  Widget _buildWithoutIndexFallback() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('results').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand));
        final filteredDocs = snapshot.data!.docs.where((doc) => (doc.data() as Map<String, dynamic>)['sClass'] == _selectedClass).toList();
        
        if (filteredDocs.isEmpty) return _buildEmptyState();
        
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            return _buildMarksheetCard(filteredDocs[index].data() as Map<String, dynamic>);
          },
        );
      }
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text('No results published for $_selectedClass', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMarksheetCard(Map<String, dynamic> data) {
    final term = data['term'] ?? 'Exam';
    final studentName = data['studentName'] ?? 'Unknown Student';
    final totalMarks = data['totalMarks'] ?? 0;
    final gpa = data['gpa'] ?? '0.00';
    final grade = data['grade'] ?? 'F';
    final Map<String, dynamic> subjects = data['subjects'] ?? {};
    
    final bool isPass = grade != 'F';

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: Offset(0, 5))],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isPass ? Colors.green.shade50 : Color(0xFFFEF2F2),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: isPass ? Color(0xFFBBF7D0) : Color(0xFFFECACA))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(term, style: TextStyle(color: isPass ? Color(0xFF166534) : Color(0xFF991B1B), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                      SizedBox(height: 4),
                      Text(studentName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    ],
                  ),
                ),
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: isPass ? Color(0xFF22C55E) : Colors.red.shade500,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: (isPass ? Color(0xFF22C55E) : Colors.red.shade500).withValues(alpha: 0.3), blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Center(
                    child: Text(grade, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ),
          
          // Subjects List
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ...subjects.entries.map((entry) {
                  final subjName = entry.key;
                  final marks = entry.value['marks'] ?? 0;
                  final subjGrade = entry.value['grade'] ?? 'F';
                  
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(subjName, style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600))),
                        Expanded(flex: 1, child: Text(marks.toString(), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                        Expanded(flex: 1, child: Text(subjGrade, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: subjGrade == 'F' ? Colors.red.shade500 : AppTheme.primaryBrand))),
                      ],
                    ),
                  );
                }),
                
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(thickness: 1),
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL MARKS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                        Text(totalMarks.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                      ],
                    ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('GPA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                        Text(gpa, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primaryBrand)),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                InkWell(
                  onTap: () {
                    PdfGenerator.generateAndPrintMarksheet(
                      studentName: studentName,
                      studentRoll: 'Not Available', // Can add roll later
                      className: data['sClass'] ?? 'Unknown',
                      examName: term,
                      subjects: subjects,
                      totalScore: totalMarks.toString(),
                      grade: grade,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14),
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
        ],
      ),
    );
  }
}





