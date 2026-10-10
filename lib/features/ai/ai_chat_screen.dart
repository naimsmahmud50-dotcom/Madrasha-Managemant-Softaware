import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Assalamu Alaikum! I am the Madrasah AI Gateway. How can I help you today? I can answer questions about exams, attendance, and fees based on the data.',
    }
  ];
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    final text = _controller.text.trim();
    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _controller.clear();
      _isTyping = true;
    });
    
    _scrollToBottom();
    _simulateAiResponse(text);
  }

  void _simulateAiResponse(String query) {
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      String response = "I couldn't find exact information for that query. Try asking about 'exam', 'fees', or 'attendance'.";
      final lowerQuery = query.toLowerCase();
      
      if (lowerQuery.contains('exam') || lowerQuery.contains('routine')) {
        response = "The Half-Yearly Examinations (1446-1447 AH) are currently scheduled. The next exam is Quran Majeed on 15 Shaban in the Main Hall.";
      } else if (lowerQuery.contains('fee') || lowerQuery.contains('due') || lowerQuery.contains('pay')) {
        response = "Based on the recent invoices, standard monthly tuition is à§³ 2,500. Some students have pending dues for Matbakh (Dining) services.";
      } else if (lowerQuery.contains('attendance') || lowerQuery.contains('present')) {
        response = "Today's staff attendance looks good! 3 staff members are present and 1 is late. No leaves have been taken today.";
      } else if (lowerQuery.contains('sabaq') || lowerQuery.contains('hifz')) {
        response = "Hifz tracking is active. Talib-e-Ilm's last updated Sabaq was Surah Yaseen 1-10.";
      } else if (lowerQuery.contains('salam') || lowerQuery.contains('assalamu alaikum')) {
        response = "Wa Alaikumussalam wa Rahmatullah! How can I assist you today?";
      }

      setState(() {
        _isTyping = false;
        _messages.add({'isUser': false, 'text': response});
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Madrasah AI Gateway', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                
                final msg = _messages[index];
                return _buildMessageBubble(msg['text'], msg['isUser']);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF7C3AED) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2))],
          border: isUser ? null : Border.all(color: const Color(0xFFDDD6FE)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : AppTheme.textPrimary,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          border: Border.all(color: const Color(0xFFDDD6FE)),
        ),
        child: Text('Typing...', style: TextStyle(color: AppTheme.primaryBrand, fontStyle: FontStyle.italic)),
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ask the AI...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(color: Color(0xFF7C3AED), shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
    );
  }
}

