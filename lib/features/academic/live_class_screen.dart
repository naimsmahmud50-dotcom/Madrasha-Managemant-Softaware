import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveClassScreen extends StatefulWidget {
  final String role;
  const LiveClassScreen({super.key, required this.role});

  @override
  State<LiveClassScreen> createState() => _LiveClassScreenState();
}

class _LiveClassScreenState extends State<LiveClassScreen> with SingleTickerProviderStateMixin {
  final List<String> _classes = ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  String _selectedClass = 'Class 8';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showScheduleClassSheet() {
    String title = '';
    String instructor = '';
    String link = '';
    String status = 'Upcoming';

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
                    Text('Schedule Live Class', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                    SizedBox(height: 16),
                    
                    TextField(
                      decoration: InputDecoration(labelText: 'Topic / Title', border: OutlineInputBorder()),
                      onChanged: (val) => title = val,
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      decoration: InputDecoration(labelText: 'Instructor Name', border: OutlineInputBorder()),
                      onChanged: (val) => instructor = val,
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      decoration: InputDecoration(labelText: 'Meeting Link (Zoom/Meet)', border: OutlineInputBorder()),
                      onChanged: (val) => link = val,
                    ),
                    SizedBox(height: 12),
                    
                    DropdownButtonFormField<String>(
                      initialValue: status,
                      decoration: InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                      items: ['Upcoming', 'Live', 'Ended'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setSheetState(() => status = val!),
                    ),
                    
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600, // Red for Live
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (title.isEmpty || instructor.isEmpty || link.isEmpty) return;

                          await FirebaseFirestore.instance.collection('live_classes').add({
                            'sClass': _selectedClass,
                            'title': title,
                            'instructor': instructor,
                            'link': link,
                            'status': status,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text('Schedule Class', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  void _updateStatus(String docId, String newStatus) {
    FirebaseFirestore.instance.collection('live_classes').doc(docId).update({'status': newStatus});
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch meeting link')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdminOrTeacher = widget.role == 'Admin' || widget.role == 'Teacher';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Live Classes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.red.shade600, // Rose Red theme for Live
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Class Filter Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedClass,
                  isExpanded: true,
                  dropdownColor: Color(0xFFBE123C),
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
              stream: FirebaseFirestore.instance.collection('live_classes')
                  .where('sClass', isEqualTo: _selectedClass)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.red.shade600));
                }
                if (snapshot.hasError) {
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
                    return _buildLiveClassCard(docs[index].id, data, isAdminOrTeacher);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdminOrTeacher
          ? FloatingActionButton.extended(
              onPressed: _showScheduleClassSheet,
              backgroundColor: Colors.red.shade600,
              icon: Icon(Icons.video_call_rounded, color: Colors.white),
              label: Text('Schedule', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildWithoutIndexFallback() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('live_classes').orderBy('createdAt', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(color: Colors.red.shade600));
        final filteredDocs = snapshot.data!.docs.where((doc) => (doc.data() as Map<String, dynamic>)['sClass'] == _selectedClass).toList();
        
        if (filteredDocs.isEmpty) return _buildEmptyState();
        
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            return _buildLiveClassCard(filteredDocs[index].id, filteredDocs[index].data() as Map<String, dynamic>, widget.role == 'Admin' || widget.role == 'Teacher');
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
          Icon(Icons.videocam_off_rounded, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text('No live classes scheduled for $_selectedClass', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLiveClassCard(String docId, Map<String, dynamic> data, bool isAdminOrTeacher) {
    final title = data['title'] ?? 'Live Class';
    final instructor = data['instructor'] ?? 'Unknown Instructor';
    final link = data['link'] ?? '';
    final status = data['status'] ?? 'Upcoming'; // 'Live', 'Upcoming', 'Ended'
    
    final isLive = status == 'Live';
    final isEnded = status == 'Ended';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isLive ? Border.all(color: Colors.red.shade600.withValues(alpha: 0.5), width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: isLive ? Color(0xFFFFF1F2) : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.cast_for_education_rounded, color: isLive ? Colors.red.shade600 : Colors.grey.shade600),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBrand))),
                          if (isLive)
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade600.withValues(alpha: _pulseAnimation.value * 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red.shade600.withValues(alpha: _pulseAnimation.value)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.red.shade600, shape: BoxShape.circle)),
                                      SizedBox(width: 4),
                                      Text('LIVE', style: TextStyle(color: Colors.red.shade600, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                );
                              },
                            )
                          else if (isEnded)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                              child: Text('ENDED', style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.bold)),
                            )
                          else
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                              child: Text('UPCOMING', style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('By $instructor', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          if (!isEnded)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isLive ? Color(0xFFFFF1F2) : Colors.grey.shade50,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLive ? Colors.red.shade600 : Color(0xFF334155),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _launchUrl(link),
                child: Text(isLive ? 'JOIN LIVE CLASS NOW' : 'Join Meeting Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            
          if (isAdminOrTeacher)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => _updateStatus(docId, 'Upcoming'),
                    child: Text('Upcoming', style: TextStyle(color: Colors.blue.shade700)),
                  ),
                  TextButton(
                    onPressed: () => _updateStatus(docId, 'Live'),
                    child: Text('Go Live', style: TextStyle(color: Colors.red.shade600)),
                  ),
                  TextButton(
                    onPressed: () => _updateStatus(docId, 'Ended'),
                    child: Text('End Class', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

