import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PtmScreen extends StatefulWidget {
  const PtmScreen({super.key});

  @override
  State<PtmScreen> createState() => _PtmScreenState();
}

class _PtmScreenState extends State<PtmScreen> {
  int _selectedTab = 0; // 0: Upcoming, 1: Feedback

  final List<Map<String, dynamic>> _meetings = [
    {
      'teacher': 'Ustadh Mahmud Khalil',
      'subject': 'Arabic Grammar',
      'date': '25 Shaban, 1447',
      'time': '04:30 PM',
      'status': 'Confirmed',
      'mode': 'Virtual (Google Meet)',
    },
    {
      'teacher': 'Maulana Abdur Rahman',
      'subject': 'Hifz Class',
      'date': '28 Shaban, 1447',
      'time': '10:00 AM',
      'status': 'Pending Approval',
      'mode': 'In-Person (Room 102)',
    },
  ];

  final List<Map<String, dynamic>> _feedbacks = [
    {
      'teacher': 'Mufti Tariq Jameel',
      'subject': 'Islamic Jurisprudence (Fiqh)',
      'date': '15 Shaban, 1447',
      'rating': 4.5,
      'comment': 'Abdullah is very attentive in class. He needs to revise the chapters on Salah more thoroughly at home. Overall excellent behavior (Husne Akhlaq).',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Slate 100
      appBar: AppBar(
        title: Text('Parent-Teacher Meetings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17)),
        backgroundColor: AppTheme.primaryBrand, // Violet 500
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.primaryBrand,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Container(
              decoration: BoxDecoration(color: Color(0xFF7C3AED), borderRadius: BorderRadius.circular(12)), // Violet 600
              child: Row(
                children: [
                  Expanded(child: _buildTabButton('Meetings', 0)),
                  Expanded(child: _buildTabButton('Teacher Feedback', 1)),
                ],
              ),
            ),
          ),
          Expanded(
            child: _selectedTab == 0 ? _buildMeetingsView() : _buildFeedbackView(),
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: AppTheme.primaryBrand,
              icon: Icon(Icons.add_rounded, color: Colors.white),
              label: Text('Request Meeting', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: Offset(0, 2))] : [],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryBrand : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingsView() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _meetings.length,
      itemBuilder: (context, index) {
        final meeting = _meetings[index];
        bool isConfirmed = meeting['status'] == 'Confirmed';
        
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isConfirmed ? AppTheme.primaryBrand.withValues(alpha: 0.3) : Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade50,
                    radius: 24,
                    child: Icon(Icons.person_rounded, color: AppTheme.primaryBrand),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meeting['teacher'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                        SizedBox(height: 4),
                        Text(meeting['subject'], style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isConfirmed ? Colors.green.shade100 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      meeting['status'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isConfirmed ? Colors.green.shade700 : Colors.orange.shade600,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.grey.shade100, height: 1),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.event_rounded, size: 16, color: Colors.grey.shade500),
                        SizedBox(width: 8),
                        Text(meeting['date'], style: TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade500),
                        SizedBox(width: 8),
                        Text(meeting['time'], style: TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.videocam_rounded, size: 16, color: Colors.grey.shade500),
                  SizedBox(width: 8),
                  Text(meeting['mode'], style: TextStyle(fontSize: 13, color: Color(0xFF334155))),
                ],
              ),
              if (isConfirmed) ...[
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBrand,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Join Virtual Meeting'),
                  ),
                )
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeedbackView() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _feedbacks.length,
      itemBuilder: (context, index) {
        final feedback = _feedbacks[index];
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 20),
                      SizedBox(width: 4),
                      Text(feedback['rating'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  ),
                  Text(feedback['date'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
              SizedBox(height: 16),
              Text(feedback['comment'], style: TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.5)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.grey.shade100, height: 1),
              ),
              Row(
                children: [
                  CircleAvatar(radius: 16, backgroundColor: Colors.grey.shade100, child: Icon(Icons.person, size: 16, color: Colors.grey.shade500)),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(feedback['teacher'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary)),
                      Text(feedback['subject'], style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

