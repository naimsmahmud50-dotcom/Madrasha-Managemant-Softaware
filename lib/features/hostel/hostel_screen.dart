import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';

class HostelScreen extends StatefulWidget {
  final String role;
  const HostelScreen({super.key, required this.role});

  @override
  State<HostelScreen> createState() => _HostelScreenState();
}

class _HostelScreenState extends State<HostelScreen> {
  void _showAddRoomSheet() {
    String roomName = '';
    int capacity = 4;
    String warden = 'Ustad Ali';

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
                    Text('Add New Room', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                    SizedBox(height: 16),
                    
                    TextField(
                      decoration: InputDecoration(labelText: 'Room Name / Number', border: OutlineInputBorder()),
                      onChanged: (val) => roomName = val,
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Capacity (Beds)', border: OutlineInputBorder()),
                      onChanged: (val) => capacity = int.tryParse(val) ?? 4,
                    ),
                    SizedBox(height: 12),

                    TextField(
                      decoration: InputDecoration(labelText: 'Warden Name', border: OutlineInputBorder()),
                      onChanged: (val) => warden = val,
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
                          if (roomName.isEmpty) return;

                          await FirebaseFirestore.instance.collection('hostel_rooms').add({
                            'room': roomName,
                            'capacity': capacity,
                            'occupied': 0, // Starts empty
                            'warden': warden,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text('Add Room', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  void _allocateStudent(String docId, int currentOccupied, int capacity) async {
    if (currentOccupied >= capacity) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Room is full!')));
      return;
    }
    await FirebaseFirestore.instance.collection('hostel_rooms').doc(docId).update({
      'occupied': currentOccupied + 1,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'Admin';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Dormitory Management', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primaryBrand,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHostelStats(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('hostel_rooms').orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No rooms added yet. Click + to add.', style: TextStyle(color: Colors.grey)),
                  );
                }

                final rooms = snapshot.data!.docs;
                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.82, 
                  ),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final roomData = rooms[index].data() as Map<String, dynamic>;
                    return _buildRoomCard(rooms[index].id, roomData, isAdmin);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: _showAddRoomSheet,
              backgroundColor: AppTheme.primaryBrand,
              child: Icon(Icons.add_home_work_rounded, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildHostelStats() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBrand,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem('Total Beds', '0', Icons.king_bed_rounded)),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(child: _buildStatItem('Occupied', '0', Icons.person_rounded)),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(child: _buildStatItem('Available', '0', Icons.check_circle_outline_rounded)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        SizedBox(height: 8),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildRoomCard(String docId, Map<String, dynamic> room, bool isAdmin) {
    final int capacity = room['capacity'] ?? 4;
    final int occupied = room['occupied'] ?? 0;
    final String warden = room['warden'] ?? 'Unknown';
    final double occupancyRate = occupied / capacity;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: occupied >= capacity ? Colors.red.shade50 : Colors.indigo.shade50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    room['room'] ?? 'Room',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: occupied >= capacity ? Colors.red.shade700 : AppTheme.primaryBrand,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isAdmin)
                  GestureDetector(
                    onTap: () => FirebaseFirestore.instance.collection('hostel_rooms').doc(docId).delete(),
                    child: Icon(Icons.delete_outline, size: 16, color: Colors.red),
                  )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(warden, style: TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$occupied/$capacity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Icon(
                      occupied >= capacity ? Icons.door_front_door_rounded : Icons.door_front_door_outlined,
                      color: occupied >= capacity ? Colors.red : Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: occupancyRate,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    occupied >= capacity ? Colors.red : Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 12),
                if (isAdmin)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _allocateStudent(docId, occupied, capacity),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        foregroundColor: AppTheme.primaryBrand,
                        side: BorderSide(color: AppTheme.primaryBrand),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Allocate', style: TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

