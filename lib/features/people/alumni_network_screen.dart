import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class AlumniNetworkScreen extends StatefulWidget {
  const AlumniNetworkScreen({super.key});

  @override
  State<AlumniNetworkScreen> createState() => _AlumniNetworkScreenState();
}

class _AlumniNetworkScreenState extends State<AlumniNetworkScreen> {
  int _selectedFilter = 0; // 0: All, 1: Mentors, 2: Donors
  final List<String> _filters = ['All Alumni', 'Available Mentors', 'Top Contributors'];

  final List<Map<String, dynamic>> _alumni = [
    {
      'name': 'Mufti Tariq Jamil',
      'batch': 'Batch 1438 AH (2017)',
      'profession': 'Imam & Khatib, Central Mosque',
      'location': 'Dhaka, Bangladesh',
      'isMentor': true,
      'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=150',
    },
    {
      'name': 'Hafez Zubair Ahmed',
      'batch': 'Batch 1440 AH (2019)',
      'profession': 'Software Engineer, Tech Solutions',
      'location': 'Kuala Lumpur, Malaysia',
      'isMentor': true,
      'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=150',
    },
    {
      'name': 'Maulana Khalid Saifullah',
      'batch': 'Batch 1435 AH (2014)',
      'profession': 'Professor of Islamic Studies',
      'location': 'Chittagong, Bangladesh',
      'isMentor': false,
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Alumni Network', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Color(0xFF0F766E), // Teal 700
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: _buildFilters(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildAlumniCard(_alumni[index]);
                },
                childCount: _alumni.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF0F766E),
        child: Icon(Icons.group_add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Color(0xFF0F766E),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connect with our Graduates', style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 8),
          Text('1,245 Registered Alumni', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: BounceWrapper(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Icon(Icons.handshake_rounded, color: Colors.white, size: 28),
                        SizedBox(height: 8),
                        Text('Mentorship', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: BounceWrapper(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Icon(Icons.favorite_rounded, color: Color(0xFF0F766E), size: 28),
                        SizedBox(height: 8),
                        Text('Give Back', style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedFilter == index;
          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF0F766E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? Color(0xFF0F766E) : Colors.grey.shade300),
                ),
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAlumniCard(Map<String, dynamic> alumni) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(alumni['image']),
                backgroundColor: Colors.grey.shade100,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(alumni['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis)),
                        if (alumni['isMentor'])
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Icon(Icons.star_rounded, size: 12, color: Colors.orange.shade600),
                                SizedBox(width: 4),
                                Text('Mentor', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange.shade600)),
                              ],
                            ),
                          )
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(alumni['batch'], style: TextStyle(fontSize: 12, color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.grey.shade100, height: 1),
          ),
          Row(
            children: [
              Icon(Icons.work_rounded, size: 16, color: Colors.grey.shade500),
              SizedBox(width: 8),
              Expanded(child: Text(alumni['profession'], style: TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500))),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 16, color: Colors.grey.shade500),
              SizedBox(width: 8),
              Expanded(child: Text(alumni['location'], style: TextStyle(fontSize: 13, color: Color(0xFF334155)))),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF0F766E),
                    side: BorderSide(color: Color(0xFF0F766E)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: Icon(Icons.message_rounded, size: 18),
                  label: Text('Message'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: Icon(Icons.handshake_rounded, size: 18),
                  label: Text('Connect'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

