import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class HifzTrackingScreen extends ConsumerStatefulWidget {
  final String role;
  const HifzTrackingScreen({super.key, required this.role});

  @override
  ConsumerState<HifzTrackingScreen> createState() => _HifzTrackingScreenState();
}

class _HifzTrackingScreenState extends ConsumerState<HifzTrackingScreen> {
  DateTime _selectedDate = DateTime.now();

  void _showAddSabaqSheet(String studentId, String studentName) {
    String sabaq = '';
    String sabaqPara = '';
    String amokhta = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                Text('Update Hifz - $studentName', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                SizedBox(height: 16),
                
                TextField(
                  decoration: InputDecoration(labelText: 'Sabaq (New Lesson)', border: OutlineInputBorder()),
                  onChanged: (val) => sabaq = val,
                ),
                SizedBox(height: 12),
                
                TextField(
                  decoration: InputDecoration(labelText: 'Sabaq Para (Recent Revision)', border: OutlineInputBorder()),
                  onChanged: (val) => sabaqPara = val,
                ),
                SizedBox(height: 12),
                
                TextField(
                  decoration: InputDecoration(labelText: 'Amokhta (Old Revision)', border: OutlineInputBorder()),
                  onChanged: (val) => amokhta = val,
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
                      if (sabaq.isEmpty && sabaqPara.isEmpty && amokhta.isEmpty) return;
                      
                      final dateStr = "\${_selectedDate.year}-\${_selectedDate.month.toString().padLeft(2, '0')}-\${_selectedDate.day.toString().padLeft(2, '0')}";
                      
                      await FirebaseFirestore.instance.collection('hifz_records').add({
                        'studentId': studentId,
                        'studentName': studentName,
                        'sabaq': sabaq,
                        'sabaqPara': sabaqPara,
                        'amokhta': amokhta,
                        'date': dateStr,
                        'createdAt': FieldValue.serverTimestamp(),
                        'teacher': 'Teacher Name', // Typically from auth
                      });
                      
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Text('Save Record', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdminOrTeacher = widget.role == 'Admin' || widget.role == 'Teacher';
    final dateStr = "\${_selectedDate.year}-\${_selectedDate.month.toString().padLeft(2, '0')}-\${_selectedDate.day.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Hifz Tracking', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
      ),
      body: Column(
        children: [
          // Date Selector Header
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: InkWell(
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
                  setState(() => _selectedDate = picked);
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
          ),
          
          Expanded(
            child: isAdminOrTeacher ? _buildTeacherView(dateStr) : _buildStudentView(dateStr),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherView(String dateStr) {
    // Show a list of students to update their Hifz, or a list of today's records
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('hifz_records').where('date', isEqualTo: dateStr).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand));
        }

        final records = snapshot.data?.docs ?? [];
        
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Records: \${records.length}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  TextButton.icon(
                    onPressed: () {
                      // In a real app, open a student selector sheet. Hardcoding a demo ID for MVP.
                      _showAddSabaqSheet('demo_student_id', 'Talib-e-Ilm');
                    },
                    icon: Icon(Icons.add, color: AppTheme.primaryBrand),
                    label: Text('Add Record', style: TextStyle(color: AppTheme.primaryBrand)),
                  )
                ],
              ),
            ),
            if (records.isEmpty)
               _buildEmptyState(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final data = records[index].data() as Map<String, dynamic>;
                  return _buildHifzCard(
                    data['studentName'] ?? 'Unknown',
                    data['sabaq'] ?? '',
                    data['sabaqPara'] ?? '',
                    data['amokhta'] ?? '',
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStudentView(String dateStr) {
    // Show current student's records
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('hifz_records').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand));
        }

        final records = snapshot.data?.docs ?? [];
        if (records.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final data = records[index].data() as Map<String, dynamic>;
            final recDate = data['date'] ?? '';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 8, top: 8),
                  child: Text(recDate, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                _buildHifzCard(
                  data['studentName'] ?? 'Unknown',
                  data['sabaq'] ?? '',
                  data['sabaqPara'] ?? '',
                  data['amokhta'] ?? '',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text('No records found.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildHifzCard(String name, String sabaq, String sabaqPara, String amokhta) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBrand.withValues(alpha: 0.05),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.person_rounded, color: AppTheme.primaryBrand, size: 20),
                SizedBox(width: 8),
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBrand, fontSize: 16)),
              ],
            ),
          ),
          
          // Metrics
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _buildMetricItem('Sabaq', sabaq.isNotEmpty ? sabaq : '-', Colors.blue)),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Expanded(child: _buildMetricItem('Sabaq Para', sabaqPara.isNotEmpty ? sabaqPara : '-', Colors.orange)),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Expanded(child: _buildMetricItem('Amokhta', amokhta.isNotEmpty ? amokhta : '-', Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String val, MaterialColor color) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color.shade700)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
