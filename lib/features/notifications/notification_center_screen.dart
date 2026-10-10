import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBEB), // Amber 50
      appBar: AppBar(
        title: Text('Notifications & SMS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange.shade500, // Amber 500
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // SMS Quota Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade500, Colors.orange.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SMS Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      SizedBox(height: 8),
                      Text('12,450 / 15,000', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                    child: Icon(Icons.sms_rounded, color: Colors.white, size: 28),
                  )
                ],
              ),
            ),

            SizedBox(height: 32),
            Text('AUTOMATED ALERTS LOG', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2)),
            SizedBox(height: 12),

            _buildNotificationTile('Absent Alert (Auto)', 'Sent to Abdullah\'s Guardian: "Your child is absent today..."', '10:30 AM', Icons.person_off_rounded, Colors.red.shade500),
            _buildNotificationTile('Fee Reminder (Bulk)', 'Sent to 45 Guardians: "Monthly fee is due tomorrow..."', 'Yesterday', Icons.payments_rounded, Color(0xFF0EA5E9)),
            _buildNotificationTile('Result Published', 'Push notification sent to all devices.', '20 Sept', Icons.star_rounded, Colors.green.shade600),
            _buildNotificationTile('Holiday Notice', 'Madrasah will remain closed for Eid.', '15 Sept', Icons.campaign_rounded, AppTheme.primaryBrand),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange.shade500,
        child: Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildNotificationTile(String title, String body, String time, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                    Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
                SizedBox(height: 6),
                Text(body, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

