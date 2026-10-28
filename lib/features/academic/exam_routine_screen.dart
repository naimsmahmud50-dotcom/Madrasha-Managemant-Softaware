import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamRoutineScreen extends StatefulWidget {
  final String role;
  const ExamRoutineScreen({super.key, required this.role});

  @override
  State<ExamRoutineScreen> createState() => _ExamRoutineScreenState();
}

class _ExamRoutineScreenState extends State<ExamRoutineScreen> {
  int _selectedTab = 0; // 0: Routine, 1: Seat Plan

  void _showAddRoutineSheet() {
    String dateStr = '';
    String dayStr = '';
    String subjectStr = '';
    String timeStr = '';
    String roomStr = '';

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
                    const Text('Add Exam Routine', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                    const SizedBox(height: 16),
                    
                    TextField(
                      decoration: const InputDecoration(labelText: 'Subject (e.g. Quran Majeed)', border: OutlineInputBorder()),
                      onChanged: (val) => subjectStr = val,
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'Date (e.g. 15 Shaban, 1447)', border: OutlineInputBorder()),
                            onChanged: (val) => dateStr = val,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'Day (e.g. Monday)', border: OutlineInputBorder()),
                            onChanged: (val) => dayStr = val,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      decoration: const InputDecoration(labelText: 'Time (e.g. 09:00 AM - 12:00 PM)', border: OutlineInputBorder()),
                      onChanged: (val) => timeStr = val,
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      decoration: const InputDecoration(labelText: 'Room (e.g. Main Hall)', border: OutlineInputBorder()),
                      onChanged: (val) => roomStr = val,
                    ),
                    
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (subjectStr.isEmpty || dateStr.isEmpty) return;

                          await FirebaseFirestore.instance.collection('exam_routines').add({
                            'subject': subjectStr,
                            'date': dateStr,
                            'day': dayStr,
                            'time': timeStr,
                            'room': roomStr,
                            'isCompleted': false,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('Add to Routine', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  void _markAsCompleted(String docId, bool currentStatus) async {
    await FirebaseFirestore.instance.collection('exam_routines').doc(docId).update({
      'isCompleted': !currentStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'Admin' || widget.role == 'Teacher';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Exam Routine & Seat Plan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF4F46E5), // Indigo 600
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _selectedTab == 0 ? _buildRoutineView(isAdmin) : _buildSeatPlanView(),
          ),
        ],
      ),
      floatingActionButton: isAdmin && _selectedTab == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddRoutineSheet,
              backgroundColor: const Color(0xFF4F46E5),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('Add Exam', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF downloaded!')));
              },
              backgroundColor: const Color(0xFF4F46E5),
              icon: const Icon(Icons.print_rounded, color: Colors.white),
              label: const Text('Download PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF4F46E5),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Half-Yearly Examination', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Academic Session: 1446-1447 AH', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3730A3), // Indigo 800
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: _buildTabButton('Routine', 0)),
                Expanded(child: _buildTabButton('Seat Plan', 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))] : [],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4F46E5) : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineView(bool isAdmin) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('exam_routines').orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(
            child: Text('No exam routines published yet.', style: TextStyle(color: Colors.grey)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildRoutineCard(doc.id, data, isAdmin);
          },
        );
      },
    );
  }

  Widget _buildRoutineCard(String docId, Map<String, dynamic> exam, bool isAdmin) {
    bool isDone = exam['isCompleted'] ?? false;
    
    // Attempt to split date nicely if formatted as "15 Shaban, 1447"
    String datePart1 = 'TBA';
    String datePart2 = '';
    
    if (exam['date'] != null && exam['date'].toString().contains(' ')) {
      var parts = exam['date'].toString().split(' ');
      datePart1 = parts[0];
      if (parts.length > 1) {
        datePart2 = parts[1].replaceAll(',', '');
      }
    } else {
      datePart1 = exam['date'] ?? 'TBA';
    }

    return GestureDetector(
      onLongPress: isAdmin ? () => _markAsCompleted(docId, isDone) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDone ? Colors.green.shade100 : Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Date Section
            Container(
              width: 80, // Fixed width to ensure text fits
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
              decoration: BoxDecoration(
                color: isDone ? Colors.green.shade600.withValues(alpha: 0.1) : Color(0xFFEEF2FF),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Text(datePart1, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDone ? Colors.green.shade600 : Color(0xFF4F46E5))),
                  const SizedBox(height: 4),
                  Text(datePart2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDone ? Colors.green.shade700 : Color(0xFF4338CA))),
                ],
              ),
            ),
            // Details Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(exam['day'] ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
                        if (isDone)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(8)),
                            child: const Text('Completed', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        else if (isAdmin)
                          const Text('Long press to mark done', style: TextStyle(color: Colors.grey, fontSize: 8)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(exam['subject'] ?? 'Unknown Subject', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(exam['time'] ?? 'TBA', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatPlanView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Admit Card Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF4F46E5)),
              boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: Column(
              children: [
                const Icon(Icons.how_to_reg_rounded, size: 48, color: Color(0xFF4F46E5)),
                const SizedBox(height: 16),
                Text('ADMIT CARD NO: 1447-802', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Text('Abdullah Al Mahmud', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                const Text('Class 8 (Mutawassitah) • Roll 101', style: TextStyle(fontSize: 14, color: Color(0xFF4F46E5), fontWeight: FontWeight.w600)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSeatDetail('Building', 'Main Block'),
                    _buildSeatDetail('Room', 'Hall 204'),
                    _buildSeatDetail('Row & Seat', 'Row 3, S-12'),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Rules
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.red.shade500),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Examination Rules', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF991B1B), fontSize: 14)),
                      SizedBox(height: 4),
                      Text('1. Bring your printed admit card.\n2. Be present 30 mins before the exam.\n3. Digital devices are strictly prohibited.', style: TextStyle(color: Color(0xFFB91C1C), fontSize: 13, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSeatDetail(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      ],
    );
  }
}

