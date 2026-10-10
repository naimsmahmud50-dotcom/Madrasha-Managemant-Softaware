import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/bounce_wrapper.dart';
import '../../core/providers/madrasah_settings_provider.dart';
import '../../core/utils/madrasah_terms.dart';

class ExamEntryScreen extends ConsumerStatefulWidget {
  const ExamEntryScreen({super.key});

  @override
  ConsumerState<ExamEntryScreen> createState() => _ExamEntryScreenState();
}

class _ExamEntryScreenState extends ConsumerState<ExamEntryScreen> {
  String? _selectedClass;
  final String _selectedSubject = 'Arabic Grammar';
  final String _examName = '1st Term Examination 2026';

  List<DocumentSnapshot> _students = [];
  bool _isLoadingStudents = false;
  
  // Mapping of Student Document ID -> Mark
  final Map<String, TextEditingController> _markControllers = {};
  bool _isSaving = false;

  void _fetchStudents() async {
    if (_selectedClass == null) return;
    setState(() => _isLoadingStudents = true);

    try {
      final snap = await FirebaseFirestore.instance
          .collection('students')
          .where('className', isEqualTo: _selectedClass)
          .get();
      
      setState(() {
        _students = snap.docs;
        // Initialize controllers for new students
        for (var doc in _students) {
          if (!_markControllers.containsKey(doc.id)) {
            _markControllers[doc.id] = TextEditingController();
          }
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading students: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingStudents = false);
      }
    }
  }

  Future<void> _saveMarks() async {
    if (_students.isEmpty) return;
    
    setState(() => _isSaving = true);
    final batch = FirebaseFirestore.instance.batch();
    
    try {
      for (var student in _students) {
        final markText = _markControllers[student.id]?.text.trim() ?? '';
        if (markText.isNotEmpty) {
          final markValue = int.tryParse(markText) ?? 0;
          final studentData = student.data() as Map<String, dynamic>;
          
          final docRef = FirebaseFirestore.instance.collection('exam_results').doc('${student.id}_$_examName');
          
          batch.set(docRef, {
            'studentId': student.id,
            'studentName': studentData['name'],
            'studentRoll': studentData['roll'],
            'className': _selectedClass,
            'examName': _examName,
            'subject': _selectedSubject,
            'mark': markValue,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }
      
      await batch.commit();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marks saved successfully!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _markControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final madrasahType = ref.watch(madrasahTypeProvider);
    final classes = MadrasahTerms.getClasses(madrasahType);
    
    if (_selectedClass == null && classes.isNotEmpty) {
      _selectedClass = classes.first;
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchStudents());
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Exam Marks Entry', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF0D5C3A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeaderSection(classes),
          Expanded(
            child: _isLoadingStudents
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D5C3A)))
                : _students.isEmpty
                    ? const Center(child: Text('No students found in this class.', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: _students.length,
                        itemBuilder: (context, index) {
                          return _buildStudentMarkCard(_students[index]);
                        },
                      ),
          ),
          if (_students.isNotEmpty) _buildBottomSubmitBar(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(List<String> classes) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D5C3A),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _examName, 
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Class/Jamaat', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedClass,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600, size: 18),
                          items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c, style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedClass = val);
                              _fetchStudents();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Subject', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Text(_selectedSubject, style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStudentMarkCard(DocumentSnapshot studentDoc) {
    final student = studentDoc.data() as Map<String, dynamic>;
    final roll = student['roll'] ?? '00';
    final name = student['name'] ?? 'Unknown';
    final controller = _markControllers[studentDoc.id]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEDE9FE),
            child: Text(roll, style: const TextStyle(color: Color(0xFF0D5C3A), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name, 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D5C3A)),
              decoration: InputDecoration(
                hintText: '---',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0D5C3A))),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomSubmitBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        child: BounceWrapper(
          onTap: _isSaving ? () {} : () => _saveMarks(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primaryBrand, AppTheme.primaryBrand]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.4), blurRadius: 12, offset: Offset(0, 4))],
            ),
            child: Center(
              child: _isSaving 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('SAVE MARKS', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
          ),
        ),
      ),
    );
  }
}



