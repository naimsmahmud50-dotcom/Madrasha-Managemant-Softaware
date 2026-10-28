import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Violet 50
      appBar: AppBar(
        title: Text('AI Governance & Assistant', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF7C3AED), // Violet 600
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Health Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7C3AED), AppTheme.primaryBrand],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Color(0xFF7C3AED).withValues(alpha: 0.3), blurRadius: 15, offset: Offset(0, 8)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('AI Engine Status', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(12)),
                          child: Text('ONLINE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAiStat('Queries Today', '1,240'),
                        Container(width: 1, height: 40, color: Colors.white24),
                        _buildAiStat('Avg Latency', '0.8s'),
                        Container(width: 1, height: 40, color: Colors.white24),
                        _buildAiStat('Accuracy', '99.9%'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),
              Text('SECURITY & GOVERNANCE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2)),
              SizedBox(height: 12),

              _buildSecurityTile('Prompt Injection Blocked', '3 attempts blocked today', Icons.security_rounded, Colors.green.shade600),
              _buildSecurityTile('Data Sanitization', 'PII scrubbed from 45 queries', Icons.privacy_tip_rounded, Color(0xFF0EA5E9)),
              
              SizedBox(height: 32),
              Text('AI WORKSPACE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2)),
              SizedBox(height: 12),
              
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AiChatScreen()));
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFDDD6FE)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF7C3AED), size: 28),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Chat with Madrasah AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                            SizedBox(height: 4),
                            Text('Ask about student performance, fee predictions, or generate reports.', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
        SizedBox(height: 8),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSecurityTile(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

