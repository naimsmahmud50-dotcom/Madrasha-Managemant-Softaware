import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../core/widgets/bounce_wrapper.dart';

class StaffAttendanceScreen extends StatefulWidget {
  final String role;
  const StaffAttendanceScreen({super.key, required this.role});

  @override
  State<StaffAttendanceScreen> createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen> {
  String _currentTime = "";
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTime());
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _updateTime() {
    if (!mounted) return;
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    setState(() {
      _currentTime = "$hour:$minute $ampm";
    });
  }

  Future<void> _punch(bool isCheckedIn, String? docId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_staff';
    
    if (isCheckedIn && docId != null) {
      // Punch Out
      await FirebaseFirestore.instance.collection('staff_attendance').doc(docId).update({
        'checkOut': FieldValue.serverTimestamp(),
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Punched Out Successfully')));
    } else {
      // Punch In
      final today = DateTime.now().toIso8601String().split('T')[0];
      await FirebaseFirestore.instance.collection('staff_attendance').add({
        'uid': uid,
        'dateString': today,
        'checkIn': FieldValue.serverTimestamp(),
        'checkOut': null,
        'status': 'Present',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Punched In Successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_staff';
    final today = DateTime.now().toIso8601String().split('T')[0];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Staff Attendance', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.blue.shade700, // Blue 600
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('staff_attendance')
            .where('uid', isEqualTo: currentUid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          
          // Find today's record
          QueryDocumentSnapshot? todayDoc;
          bool isCheckedIn = false;
          
          try {
            todayDoc = docs.firstWhere((doc) => (doc.data() as Map<String, dynamic>)['dateString'] == today);
            final data = todayDoc.data() as Map<String, dynamic>;
            // If they have checked in but not checked out, they are currently checked in
            if (data['checkIn'] != null && data['checkOut'] == null) {
              isCheckedIn = true;
            }
          } catch (e) {
            // No record for today
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildCheckInCard(isCheckedIn, todayDoc?.id),
                SizedBox(height: 24),
                _buildMonthlyStats(docs),
                SizedBox(height: 24),
                _buildAttendanceLogs(docs),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCheckInCard(bool isCheckedIn, String? todayDocId) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        children: [
          Text('Current Time', style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 8),
          Text(_currentTime, style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 2)),
          SizedBox(height: 32),
          BounceWrapper(
            onTap: () => _punch(isCheckedIn, todayDocId),
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCheckedIn ? Colors.red.shade500 : Colors.green.shade600,
                boxShadow: [
                  BoxShadow(
                    color: isCheckedIn ? Colors.red.shade500.withValues(alpha: 0.4) : Colors.green.shade600.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isCheckedIn ? Icons.logout_rounded : Icons.fingerprint_rounded, size: 50, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    isCheckedIn ? 'PUNCH OUT' : 'PUNCH IN',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_rounded, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text('Madrasah Campus', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStats(List<QueryDocumentSnapshot> docs) {
    int present = docs.length;
    int late = docs.where((d) {
      final data = d.data() as Map<String, dynamic>;
      return data['status'] == 'Late';
    }).length;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _buildStatItem('Present', present.toString(), Colors.green.shade600)),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          Expanded(child: _buildStatItem('Late', late.toString(), Colors.orange.shade500)),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          Expanded(child: _buildStatItem('Leaves', '0', Colors.red.shade500)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildAttendanceLogs(List<QueryDocumentSnapshot> docs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RECENT LOGS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          SizedBox(height: 12),
          if (docs.isEmpty)
            Center(child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No attendance logs yet.', style: TextStyle(color: Colors.grey)),
            )),
          ...docs.take(10).map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _buildLogCard(data);
          }),
        ],
      ),
    );
  }

  Widget _buildLogCard(Map<String, dynamic> data) {
    final status = data['status'] ?? 'Unknown';
    Color statusColor = Colors.green.shade600;
    if (status == 'Late') statusColor = Colors.orange.shade500;
    if (status == 'Leave') statusColor = Colors.red.shade500;
    
    String checkInTime = '--:--';
    String checkOutTime = '--:--';
    
    if (data['checkIn'] != null) {
      final t = (data['checkIn'] as Timestamp).toDate();
      checkInTime = '${t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour)}:${t.minute.toString().padLeft(2, '0')} ${t.hour >= 12 ? 'PM' : 'AM'}';
    }
    if (data['checkOut'] != null) {
      final t = (data['checkOut'] as Timestamp).toDate();
      checkOutTime = '${t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour)}:${t.minute.toString().padLeft(2, '0')} ${t.hour >= 12 ? 'PM' : 'AM'}';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['dateString'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeColumn('Check In', checkInTime, Icons.login_rounded, Colors.green.shade600),
              Container(width: 1, height: 30, color: Colors.grey.shade100),
              _buildTimeColumn('Check Out', checkOutTime, Icons.logout_rounded, Colors.red.shade500),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTimeColumn(String label, String time, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.7)),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            Text(time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          ],
        )
      ],
    );
  }
}

