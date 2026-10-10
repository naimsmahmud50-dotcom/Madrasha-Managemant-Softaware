import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ZakatManagementScreen extends StatefulWidget {
  const ZakatManagementScreen({super.key});

  @override
  State<ZakatManagementScreen> createState() => _ZakatManagementScreenState();
}

class _ZakatManagementScreenState extends State<ZakatManagementScreen> {
  final List<Map<String, dynamic>> _recentCollections = [
    {
      'donor': 'Anonymous (Dubai)',
      'type': 'Zakat',
      'amount': 'Ã¢Â‚Â§ 50,000',
      'date': 'Today, 10:30 AM',
      'isZakat': true,
    },
    {
      'donor': 'Haji Abdul Karim',
      'type': 'Sadaqah Jariyah',
      'amount': 'Ã¢Â‚Â§ 15,000',
      'date': 'Yesterday, 04:15 PM',
      'isZakat': false,
    },
    {
      'donor': 'Dr. Shafiqur Rahman',
      'type': 'Lillah (Orphanage)',
      'amount': 'Ã¢Â‚Â§ 1,00,000',
      'date': '20 Shaban, 1447',
      'isZakat': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Zakat & Sadaqah Manager', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17)),
        backgroundColor: Colors.green.shade700, // Emerald 600
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Fund Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  TextButton(
                    onPressed: () {},
                    child: Text('View Report', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildCategoryRow()),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Text('Recent Collections', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildCollectionCard(_recentCollections[index]);
                },
                childCount: _recentCollections.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.green.shade700,
        icon: Icon(Icons.add_card_rounded, color: Colors.white),
        label: Text('New Entry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Text('Total Fund Collected (Ramadan Campaign)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Ã¢Â‚Â§ 12,50,000', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1)),
          SizedBox(height: 24),
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Campaign Target: Ã¢Â‚Â§ 20,00,000', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  Text('62%', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.625,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFBBF24)), // Amber
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildCategoryCard('Zakat Fund', 'Strictly for poor students', 'Ã¢Â‚Â§ 8,00,000', Color(0xFF0EA5E9), Icons.volunteer_activism_rounded)),
          SizedBox(width: 12),
          Expanded(child: _buildCategoryCard('Lillah / Sadaqah', 'General Madrasah operations', 'Ã¢Â‚Â§ 4,50,000', AppTheme.primaryBrand, Icons.mosque_rounded)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String desc, String amount, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 16),
          Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(desc, style: TextStyle(fontSize: 10, color: Colors.grey.shade600), maxLines: 2),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(Map<String, dynamic> item) {
    bool isZakat = item['isZakat'];
    Color typeColor = isZakat ? Color(0xFF0EA5E9) : AppTheme.primaryBrand;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: Offset(0, 2))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(isZakat ? Icons.volunteer_activism_rounded : Icons.mosque_rounded, color: typeColor, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['donor'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(item['type'], style: TextStyle(color: typeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8),
                    Text(item['date'], style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                )
              ],
            ),
          ),
          Text(item['amount'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green.shade700)),
        ],
      ),
    );
  }
}

