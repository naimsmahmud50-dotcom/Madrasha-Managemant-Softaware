import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MpoTrackingScreen extends StatelessWidget {
  const MpoTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> teachers = [
      {
        'name': 'Maulana Hafizur Rahman',
        'designation': 'Assistant Teacher (Islamiyat)',
        'mpoStatus': 'MPO Enlisted',
        'indexNo': 'IDX-104829',
        'training': 'B.Ed (Completed), NAEM (Pending)',
        'color': Colors.green.shade600 // Green
      },
      {
        'name': 'Abdur Rahim',
        'designation': 'Assistant Teacher (Mathematics)',
        'mpoStatus': 'Pending (Application Submitted)',
        'indexNo': 'N/A',
        'training': 'B.Ed (Ongoing)',
        'color': Colors.orange.shade500 // Amber
      },
      {
        'name': 'Kazi Shafiqul Islam',
        'designation': 'Lecturer (Arabic)',
        'mpoStatus': 'MPO Enlisted',
        'indexNo': 'IDX-839201',
        'training': 'M.Ed (Completed), NTRCA Qualified',
        'color': Colors.green.shade600 // Green
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('MPO & Training Records', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Color(0xFF4F46E5), // Indigo
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                return _buildTeacherCard(teachers[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Color(0xFF4F46E5),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Staff MPO & Certifications', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Track government MPO index numbers, salary status, and NTRCA/B.Ed training records.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by Teacher Name or Index...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.8)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.15),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTeacherCard(Map<String, dynamic> teacher) {
    bool isMpo = teacher['mpoStatus'] == 'MPO Enlisted';
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                child: Icon(Icons.person_rounded, color: isMpo ? Color(0xFF4F46E5) : Colors.grey.shade500),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(teacher['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                    SizedBox(height: 2),
                    Text(teacher['designation'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('MPO Status:', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    Row(
                      children: [
                        if (isMpo) Icon(Icons.verified_rounded, size: 14, color: Colors.green.shade600),
                        SizedBox(width: 4),
                        Text(teacher['mpoStatus'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: teacher['color'])),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: Colors.grey.shade300),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Index No:', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    Text(teacher['indexNo'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: Colors.grey.shade300),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Training & Cert:', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        teacher['training'],
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

