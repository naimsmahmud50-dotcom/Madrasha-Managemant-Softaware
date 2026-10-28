import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/bounce_wrapper.dart';
import 'inventory_screen.dart';

class OperationsScreen extends StatelessWidget {
  const OperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Operations & Admin', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        elevation: 0,
        backgroundColor: AppTheme.primaryBrand,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Stats
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Total Staff', '45', Icons.people_rounded, Color(0xFF0EA5E9))),
                        SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Present Today', '42', Icons.how_to_reg_rounded, Colors.green.shade600)),
                        SizedBox(width: 12),
                        Expanded(child: _buildStatCard('On Leave', '3', Icons.event_busy_rounded, Colors.orange.shade500)),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PENDING LEAVE REQUESTS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2)),
                    SizedBox(height: 12),
                    
                    // Leave Requests
                    _buildLeaveRequestTile('Maulana Abdur Rahman', 'Hifz Teacher', 'Sick Leave (2 Days)', '23 Sept - 24 Sept'),
                    _buildLeaveRequestTile('Hafiz Zubair', 'Maktab Teacher', 'Personal Leave (1 Day)', '25 Sept'),
                    
                    SizedBox(height: 24),
                    
                    Text('INVENTORY ALERTS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2)),
                    SizedBox(height: 12),
                    
                    // Inventory Alerts
                    _buildInventoryTile(context, 'Hostel Food Supply', 'Low Stock (Rice & Dal)', Icons.restaurant_rounded, Colors.red.shade500),
                    _buildInventoryTile(context, 'Library Books', '12 Books overdue for return', Icons.menu_book_rounded, Colors.orange.shade500),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestTile(String name, String role, String type, String date) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text('Pending', style: TextStyle(color: Colors.orange.shade600, fontWeight: FontWeight.bold, fontSize: 11)),
              )
            ],
          ),
          SizedBox(height: 4),
          Text(role, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.event_note_rounded, size: 16, color: Color(0xFF0EA5E9)),
              SizedBox(width: 8),
              Text('$type • $date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red.shade500, side: BorderSide(color: Colors.red.shade500)),
                  child: Text('Reject'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, foregroundColor: Colors.white),
                  child: Text('Approve'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInventoryTile(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return BounceWrapper(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryScreen()));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

