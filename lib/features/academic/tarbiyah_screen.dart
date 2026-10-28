import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class TarbiyahScreen extends StatefulWidget {
  const TarbiyahScreen({super.key});

  @override
  State<TarbiyahScreen> createState() => _TarbiyahScreenState();
}

class _TarbiyahScreenState extends State<TarbiyahScreen> {
  String _selectedClass = 'Class 8 (Mutawassitah)';
  
  final List<Map<String, dynamic>> _students = [
    {'name': 'Abdullah Al Mahmud', 'roll': '101', 'score': 95, 'recent': 'Led Prayer', 'recentColor': Colors.green.shade600},
    {'name': 'Omar Faruk', 'roll': '102', 'score': 72, 'recent': 'Late in Jamaat', 'recentColor': Colors.red.shade500},
    {'name': 'Osman Goni', 'roll': '103', 'score': 88, 'recent': 'Cleaned Classroom', 'recentColor': Colors.green.shade600},
    {'name': 'Ali Ibn Abi Talib', 'roll': '104', 'score': 92, 'recent': 'Helped Peer', 'recentColor': Colors.green.shade600},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 50
      appBar: AppBar(
        title: Text('Tarbiyah & Akhlaq', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Color(0xFF047857), // Emerald 700
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: Icon(Icons.history_edu_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                return _buildStudentCard(_students[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRecordModal(context),
        backgroundColor: Color(0xFF047857),
        icon: Icon(Icons.add_task_rounded, color: Colors.white),
        label: Text('Add Record', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Color(0xFF047857),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Color(0x33047857), blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedClass,
                dropdownColor: Colors.green.shade900,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                items: ['Class 8 (Mutawassitah)', 'Class 9 (Sanawiyyah)', 'Hifz-A'].map((String val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedClass = val);
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildSummaryStat('Class Avg.', '86/100', Icons.analytics_rounded)),
              Container(width: 1, height: 40, color: Colors.white24),
              Expanded(child: _buildSummaryStat('Needs Attention', '3', Icons.warning_amber_rounded)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade100, size: 24),
        SizedBox(height: 8),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    int score = student['score'];
    Color scoreColor = score >= 90 ? Colors.green.shade600 : (score >= 75 ? Colors.orange.shade500 : Colors.red.shade500);

    return BounceWrapper(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            // Score Circle
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 4,
                    backgroundColor: scoreColor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  ),
                  Center(
                    child: Text(
                      score.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: scoreColor),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                        child: Text('Roll ${student['roll']}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Recent: ${student['recent']}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: student['recentColor']),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _showAddRecordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Log Tarbiyah Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text('Select Category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionTile('Husne Akhlaq', 'Positive points', Icons.thumb_up_rounded, Colors.green.shade600),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildActionTile('Infraction', 'Negative points', Icons.thumb_down_rounded, Colors.red.shade500),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text('Select Student', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select a student'),
                        isExpanded: true,
                        items: _students.map((s) => DropdownMenuItem(value: s['name'] as String, child: Text(s['name'] as String))).toList(),
                        onChanged: (val) {},
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                    child: TextField(
                      maxLines: 3,
                      decoration: InputDecoration(border: InputBorder.none, hintText: 'What did the student do?'),
                    ),
                  ),
                  SizedBox(height: 32),
                  BounceWrapper(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record added successfully!'), backgroundColor: Color(0xFF047857)));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Color(0xFF047857), borderRadius: BorderRadius.circular(16)),
                      child: Text('SUBMIT RECORD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
          SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 11)),
        ],
      ),
    );
  }
}

