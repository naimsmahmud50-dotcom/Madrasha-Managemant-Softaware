import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDetailScreen extends StatefulWidget {
  final String roomId;
  final String name;
  final String role;
  final Color avatarColor;

  const ChatDetailScreen({
    super.key,
    required this.roomId,
    required this.name,
    required this.role,
    required this.avatarColor,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final text = _controller.text.trim();
    _controller.clear();
    
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';
    final currentEmail = FirebaseAuth.instance.currentUser?.email ?? 'User';

    // Add message
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.roomId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': currentUid,
      'senderName': currentEmail.split('@')[0],
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update room last message
    await FirebaseFirestore.instance.collection('chat_rooms').doc(widget.roomId).update({
      'lastMessage': text,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: const Color(0xFF14B8A6), // Teal 500
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white24,
              child: Text(widget.name.isNotEmpty ? widget.name.substring(0, 1) : 'G', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  Text(widget.role, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(widget.roomId)
                  .collection('messages')
                  .orderBy('createdAt')
                  .limitToLast(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
                }

                final docs = snapshot.data?.docs ?? [];
                
                // Scroll to bottom after frame if new message
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    bool isMe = data['senderId'] == currentUid;
                    return _buildMessageBubble(data['text'] ?? '', isMe, data['senderName'] ?? 'User');
                  },
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe, String senderName) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(senderName, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF14B8A6) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 20),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : AppTheme.textPrimary,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(color: Color(0xFF14B8A6), shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

