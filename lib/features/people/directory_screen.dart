import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/widgets/bounce_wrapper.dart';
import '../../core/theme/app_theme.dart';
import 'student_profile_screen.dart';
import 'teacher_profile_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 50
      appBar: AppBar(
        title: Text('People Directory', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF1E3A8A), // Deep Indigo
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: Column(
            children: [
              _buildSearchBar(),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: [
                  Tab(text: 'STUDENTS'),
                  Tab(text: 'STAFF & TEACHERS'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStudentsTab(),
          _buildStaffTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF1E3A8A),
        child: Icon(Icons.person_add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by name, ID, or phone...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildStudentsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('students').orderBy('createdAt', descending: true).limit(50).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color(0xFF1E3A8A)));
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) return Center(child: Text('No students found.'));
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return _buildPersonCard(
              name: data['name'] ?? 'Unknown',
              id: 'STU-${data['roll'] ?? '000'}',
              subtitle: data['className'] ?? 'Unknown Class',
              phone: data['guardianPhone'] ?? 'No Phone',
              avatarColor: Color(0xFF0EA5E9),
              isStudent: true
            );
          }
        );
      }
    );
  }

  Widget _buildStaffTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'Teacher').limit(50).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color(0xFF1E3A8A)));
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) return Center(child: Text('No teachers found.'));
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return _buildPersonCard(
              name: 'Teacher',
              id: docs[index].id.substring(0, 8).toUpperCase(),
              subtitle: 'Teacher - ${data['status'] ?? 'Pending'}',
              phone: data['phone'] ?? 'No Phone',
              avatarColor: Colors.blue.shade600,
              isStudent: false
            );
          }
        );
      }
    );
  }

  Widget _buildPersonCard({
    required String name,
    required String id,
    required String subtitle,
    required String phone,
    required Color avatarColor,
    required bool isStudent,
  }) {
    return BounceWrapper(
      onTap: () {
        if (isStudent) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StudentProfileScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherProfileScreen()));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: avatarColor.withValues(alpha: 0.1),
              child: Text(
                name.substring(0, 1),
                style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                  SizedBox(height: 2),
                  Text(id, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                  SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.message_rounded, color: Color(0xFF0EA5E9), size: 22),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xFFF0F9FF),
                    padding: EdgeInsets.all(8),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.call_rounded, color: Colors.green.shade600, size: 22),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}



