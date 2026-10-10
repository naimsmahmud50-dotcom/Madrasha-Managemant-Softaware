import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GatePassScreen extends StatefulWidget {
  const GatePassScreen({super.key});

  @override
  State<GatePassScreen> createState() => _GatePassScreenState();
}

class _GatePassScreenState extends State<GatePassScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 50
      appBar: AppBar(
        title: Text('Digital Gate Pass', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primaryBrand, // Slate 900 (Security theme)
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF38BDF8),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'ACTIVE PASSES'),
            Tab(text: 'REQUESTS'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF38BDF8)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening Scanner...')));
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivePassesTab(),
          _buildRequestsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primaryBrand,
        icon: Icon(Icons.add_rounded, color: Colors.white),
        label: Text('New Pass', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildActivePassesTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildTicketCard(
          studentName: 'Abdullah Al Mahmud',
          roll: 'STU-0891 (Class 8)',
          reason: 'Medical Checkup',
          outTime: 'Today, 10:00 AM',
          expectedInTime: 'Today, 02:00 PM',
          status: 'OUT',
          statusColor: Colors.orange.shade500, // Amber
        ),
        SizedBox(height: 16),
        _buildTicketCard(
          studentName: 'Zaid Ibn Haritha',
          roll: 'STU-2026 (Class 5)',
          reason: 'Weekend Home Visit',
          outTime: 'Yesterday, 04:00 PM',
          expectedInTime: 'Sunday, 08:00 AM',
          status: 'OUT',
          statusColor: Colors.orange.shade500, // Amber
        ),
      ],
    );
  }

  Widget _buildRequestsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildTicketCard(
          studentName: 'Abdur Rahman',
          roll: 'STU-1205 (Hifz)',
          reason: 'Family Function',
          outTime: 'Tomorrow, 09:00 AM',
          expectedInTime: 'Tomorrow, 06:00 PM',
          status: 'PENDING',
          statusColor: Colors.grey.shade600, // Slate
          showActions: true,
        ),
      ],
    );
  }

  Widget _buildTicketCard({
    required String studentName,
    required String roll,
    required String reason,
    required String outTime,
    required String expectedInTime,
    required String status,
    required Color statusColor,
    bool showActions = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Top Part
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade100,
                  radius: 24,
                  child: Icon(Icons.person_rounded, color: statusColor, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(studentName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                      SizedBox(height: 4),
                      Text(roll, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
                      ),
                    ],
                  ),
                ),
                // QR Code thumbnail indicator
                Icon(Icons.qr_code_2_rounded, size: 40, color: Colors.grey.shade400),
              ],
            ),
          ),
          
          // Divider with Cutouts
          Row(
            children: [
              Container(
                width: 10, height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
              ),
              Expanded(
                child: CustomPaint(
                  painter: DashedLinePainter(),
                ),
              ),
              Container(
                width: 10, height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                ),
              ),
            ],
          ),

          // Bottom Part
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey.shade500),
                    SizedBox(width: 8),
                    Expanded(child: Text('Reason: $reason', style: TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w500))),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeBlock('OUT TIME', outTime, Icons.logout_rounded, Color(0xFF0EA5E9)),
                    _buildTimeBlock('EXPECTED IN', expectedInTime, Icons.login_rounded, Colors.green.shade600),
                  ],
                ),
                if (showActions) ...[
                  SizedBox(height: 16),
                  Divider(color: Colors.grey.shade100),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade500,
                            side: BorderSide(color: Colors.red.shade500),
                          ),
                          child: Text('Reject'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Approve'),
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBlock(String label, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: color),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5)),
            SizedBox(height: 2),
            Text(time, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          ],
        )
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.5;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2), Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

