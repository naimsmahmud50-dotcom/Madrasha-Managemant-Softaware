import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/madrasah_settings_provider.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  final String role;
  AttendanceScreen({super.key, required this.role});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedClass;
  bool _isLoading = false;
  
  // phone -> status (P, A, L)
  final Map<String, String> _attendanceMap = {};

  final List<String> _aliaClasses = ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Alim 1st', 'Alim 2nd'];
  final List<String> _qawmiClasses = ['Ibtidaa-ee', 'Mutawassitah', 'Sanawiyyah', 'Fadilat', 'Takmil'];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitAttendance(List<QueryDocumentSnapshot> students) async {
    if (_selectedClass == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final batch = FirebaseFirestore.instance.batch();
      
      final dateStr = "\${_selectedDate.year}-\${_selectedDate.month.toString().padLeft(2, '0')}-\${_selectedDate.day.toString().padLeft(2, '0')}";
      
      for (var student in students) {
        final data = student.data() as Map<String, dynamic>;
        final phone = data['phone'] as String;
        final status = _attendanceMap[phone] ?? 'P'; // Default to Present
        
        final docRef = FirebaseFirestore.instance.collection('attendance').doc("\${phone}_\$dateStr");
        batch.set(docRef, {
          'studentPhone': phone,
          'studentName': data['name'] ?? 'Unknown',
          'sClass': _selectedClass,
          'date': dateStr,
          'timestamp': FieldValue.serverTimestamp(),
          'status': status,
          'markedBy': widget.role,
        });
      }

      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance submitted successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: \$e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final madrasahType = ref.watch(madrasahTypeProvider);
    final isAdminOrTeacher = widget.role == 'Admin' || widget.role == 'Teacher';
    
    final currentClasses = madrasahType == MadrasahType.qawmi ? _qawmiClasses : _aliaClasses;
    if (_selectedClass == null || !currentClasses.contains(_selectedClass)) {
      _selectedClass = currentClasses.first;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Attendance', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Date Selector
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppTheme.primaryBrand,
                              onPrimary: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, color: AppTheme.primaryBrand),
                            SizedBox(width: 12),
                            Text(
                              "\${_selectedDate.day}/\${_selectedDate.month}/\${_selectedDate.year}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                
                // Class Selector
                if (isAdminOrTeacher)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedClass,
                        items: currentClasses.map((String c) {
                          return DropdownMenuItem(value: c, child: Text(c, style: TextStyle(fontWeight: FontWeight.w500)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedClass = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'Student').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand));
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                // Filter locally to avoid missing composite index errors
                final students = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['sClass'] == _selectedClass;
                }).toList();

                if (students.isEmpty) {
                  return _buildEmptyState();
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final doc = students[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final phone = data['phone'] as String;
                          final name = data['name'] ?? 'Unknown';
                          final roll = data['roll'] ?? 'N/A';
                          
                          // Set default to 'P' if not set
                          _attendanceMap.putIfAbsent(phone, () => 'P');
                          
                          return _buildStudentAttendanceCard(name, roll, phone, isReadOnly: !isAdminOrTeacher);
                        },
                      ),
                    ),
                    if (isAdminOrTeacher)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, -5))
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBrand,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _isLoading ? null : () => _submitAttendance(students),
                            child: _isLoading 
                                ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text('Submit Attendance', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.how_to_reg_rounded, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text('No students found in \$_selectedClass', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildStudentAttendanceCard(String name, String roll, String phone, {bool isReadOnly = false}) {
    String currentStatus = _attendanceMap[phone] ?? 'P';
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryBrand.withValues(alpha: 0.1),
            child: Text(name.isNotEmpty ? name[0] : '?', style: TextStyle(color: AppTheme.primaryBrand, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                SizedBox(height: 4),
                Text('Roll: \$roll | \$phone', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          if (!isReadOnly)
            Row(
              children: [
                _buildStatusButton('P', Colors.green, currentStatus == 'P', () {
                  setState(() => _attendanceMap[phone] = 'P');
                }),
                SizedBox(width: 8),
                _buildStatusButton('A', Colors.red, currentStatus == 'A', () {
                  setState(() => _attendanceMap[phone] = 'A');
                }),
                SizedBox(width: 8),
                _buildStatusButton('L', Colors.orange, currentStatus == 'L', () {
                  setState(() => _attendanceMap[phone] = 'L');
                }),
              ],
            )
          else 
             Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Present', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
             )
        ],
      ),
    );
  }

  Widget _buildStatusButton(String text, Color color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? color : Colors.transparent),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
