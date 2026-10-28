import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_detail_screen.dart';

class MessagingScreen extends StatelessWidget {
  final String role;
  const MessagingScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
        backgroundColor: const Color(0xFF14B8A6), // Teal 500
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF14B8A6),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildSegmentedControl(),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chat_rooms').orderBy('lastUpdated', descending: true).limit(30).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
                }

                final docs = snapshot.data?.docs ?? [];
                
                if (docs.isEmpty) {
                  return const Center(child: Text('No active conversations.', style: TextStyle(color: Colors.grey)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildChatTile(
                      context,
                      roomId: docs[index].id,
                      name: data['title'] ?? 'Unknown Group',
                      role: data['subtitle'] ?? 'Chat',
                      lastMessage: data['lastMessage'] ?? '...',
                      avatarColor: Colors.blue.shade600,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: role == 'Admin' || role == 'Teacher' ? FloatingActionButton(
        onPressed: () => _createChatRoom(context),
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ) : null,
    );
  }

  void _createChatRoom(BuildContext context) {
    String title = '';
    String subtitle = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Conversation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: const InputDecoration(labelText: 'Chat Title (e.g. Class 8 Parents)'), onChanged: (v) => title = v),
              TextField(decoration: const InputDecoration(labelText: 'Subtitle (e.g. General Announcement)'), onChanged: (v) => subtitle = v),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (title.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('chat_rooms').add({
                    'title': title,
                    'subtitle': subtitle,
                    'lastMessage': 'Chat created',
                    'lastUpdated': FieldValue.serverTimestamp(),
                  });
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            )
          ],
        );
      },
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: const Text('Direct', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF14B8A6))),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text('Groups', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, {required String roomId, required String name, required String role, required String lastMessage, required Color avatarColor}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(
          roomId: roomId,
          name: name,
          role: role,
          avatarColor: avatarColor,
        )));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: avatarColor.withValues(alpha: 0.1),
              child: Text(name.isNotEmpty ? name[0] : 'G', style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(role, style: TextStyle(fontSize: 12, color: Colors.blue.shade600, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(lastMessage, style: TextStyle(fontSize: 13, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

