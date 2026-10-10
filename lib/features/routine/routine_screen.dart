import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/madrasah_settings_provider.dart';

class RoutineScreen extends ConsumerStatefulWidget {
  final String role;
  const RoutineScreen({super.key, required this.role});

  @override
  ConsumerState<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends ConsumerState<RoutineScreen> {
  String _selectedDay = 'Saturday';
  String? _selectedClass;

  final List<String> _days = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  final List<String> _aliaClasses = ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Alim 1st'];
  final List<String> _qawmiClasses = ['Mutawassitah', 'Sanawiyyah', 'Fadilat', 'Takmil'];

  @override
  void initState() {
    super.initState();
    _selectedDay = _getTodayString();
  }

  String _getTodayString() {
    switch (DateTime.now().weekday) {
      case DateTime.monday: return 'Monday';
      case DateTime.tuesday: return 'Tuesday';
      case DateTime.wednesday: return 'Wednesday';
      case DateTime.thursday: return 'Thursday';
      case DateTime.friday: return 'Friday';
      case DateTime.saturday: return 'Saturday';
      case DateTime.sunday: return 'Sunday';
      default: return 'Saturday';
    }
  }

  void _showAddRoutineSheet() {
    String subject = '';
    String time = '';
    String teacher = '';
    
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
                Text('Add Routine - $_selectedClass', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                const SizedBox(height: 16),
                
                TextField(decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()), onChanged: (val) => subject = val),
                const SizedBox(height: 12),
                
                TextField(decoration: const InputDecoration(labelText: 'Time (e.g. 09:00 AM - 09:45 AM)', border: OutlineInputBorder()), onChanged: (val) => time = val),
                const SizedBox(height: 12),
                
                TextField(decoration: const InputDecoration(labelText: 'Teacher Name', border: OutlineInputBorder()), onChanged: (val) => teacher = val),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBrand,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      if (subject.isEmpty || time.isEmpty) return;
                      
                      await FirebaseFirestore.instance.collection('routines').add({
                        'day': _selectedDay,
                        'sClass': _selectedClass,
                        'subject': subject,
                        'time': time,
                        'teacher': teacher,
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                      
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('Save Period', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
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
    final madrasahType = ref.watch(madrasahTypeProvider);
    final currentClasses = madrasahType == MadrasahType.qawmi ? _qawmiClasses : _aliaClasses;
    
    if (_selectedClass == null || !currentClasses.contains(_selectedClass)) {
      _selectedClass = currentClasses.first;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Class Routine', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
      ),
      body: Column(
        children: [
          // Header / Filter
          Container(
            color: Colors.white,
            child: Column(
              children: [
                // Day Selector
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _days.length,
                    itemBuilder: (context, index) {
                      final day = _days[index];
                      final isSelected = day == _selectedDay;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = day),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryBrand : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? AppTheme.primaryBrand : Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Class Selector
                if (isAdminOrTeacher)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedClass,
                          items: currentClasses.map((String c) {
                            return DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.w500)));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedClass = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('routines')
                  .where('day', isEqualTo: _selectedDay)
                  .where('sClass', isEqualTo: _selectedClass)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand));
                }
                
                final routines = snapshot.data?.docs ?? [];
                
                if (routines.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_rounded, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('No routine set for $_selectedDay', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: routines.length,
                  itemBuilder: (context, index) {
                    final data = routines[index].data() as Map<String, dynamic>;
                    return _buildRoutineCard(
                      data['subject'] ?? 'Unknown',
                      data['time'] ?? '00:00 - 00:00',
                      data['teacher'] ?? 'Unknown Teacher',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdminOrTeacher
          ? FloatingActionButton.extended(
              onPressed: _showAddRoutineSheet,
              backgroundColor: AppTheme.primaryBrand,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Period', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildRoutineCard(String subject, String time, String teacher) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppTheme.primaryBrand.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule_rounded, color: AppTheme.primaryBrand, size: 24),
                const SizedBox(height: 8),
                Text(
                  time.split('-').first.trim(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryBrand),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person_rounded, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(teacher, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(time, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
