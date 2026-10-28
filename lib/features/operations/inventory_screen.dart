import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Slate 100
      appBar: AppBar(
        title: Text('Inventory & Assets', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Color(0xFF334155), // Slate 700
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeaderStats(),
          SizedBox(height: 16),
          _buildSearchBar(),
          SizedBox(height: 24),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CATEGORIES', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569), letterSpacing: 1.2)),
                      TextButton(
                        onPressed: () {},
                        child: Text('Add Item', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _buildCategories(),
                  SizedBox(height: 24),
                  
                  Text('CRITICAL LOW STOCK', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFDC2626), letterSpacing: 1.2)),
                  SizedBox(height: 12),
                  _buildStockItem('Basmati Rice (Matbakh)', 'Current: 15 kg', 'Min Req: 50 kg', Colors.red.shade500),
                  _buildStockItem('Cooking Oil (Soyabean)', 'Current: 5 L', 'Min Req: 20 L', Colors.red.shade500),
                  
                  SizedBox(height: 24),
                  
                  Text('RECENTLY ADDED', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569), letterSpacing: 1.2)),
                  SizedBox(height: 12),
                  _buildStockItem('Hostel Beds (Single)', 'Current: 120 pcs', 'Added: +5 pcs', Colors.green.shade600, isAlert: false),
                  _buildStockItem('Whiteboard Markers', 'Current: 45 boxes', 'Added: +20 boxes', Colors.green.shade600, isAlert: false),
                  _buildStockItem('Ceiling Fans (Classroom)', 'Current: 35 pcs', 'Added: +2 pcs', Colors.green.shade600, isAlert: false),
                  
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStats() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF334155),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Color(0xFF334155).withValues(alpha: 0.3), blurRadius: 15, offset: Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMiniStatCard('Total Items', '1,450', Icons.inventory_2_rounded, Color(0xFF0EA5E9)),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildMiniStatCard('Total Value', '৳ 2.5M', Icons.account_balance_wallet_rounded, Colors.green.shade600),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(String title, String amount, IconData icon, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(amount, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(title, style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search assets, food stock, stationery...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            icon: Icon(Icons.search_rounded, color: Colors.grey.shade500),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 150, // Increased drastically to guarantee no vertical overflow (14 pixels)
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 16), // Prevents shadow clipping
        children: [
          _buildCategoryCard('Matbakh', '140 Items', Icons.restaurant_rounded, Colors.orange.shade500),
          _buildCategoryCard('Hostel', '45 Items', Icons.bed_rounded, Colors.blue.shade600),
          _buildCategoryCard('Stationery', '210 Items', Icons.edit_rounded, AppTheme.primaryBrand),
          _buildCategoryCard('Furniture', '85 Items', Icons.chair_rounded, Colors.green.shade600),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String count, IconData icon, Color color) {
    return BounceWrapper(
      onTap: () {},
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Prevents expanding errors
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 12), // Replaced Spacer with fixed box
            Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)), maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: 2),
            Text(count, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildStockItem(String title, String currentStock, String statusText, Color statusColor, {bool isAlert = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isAlert ? Color(0xFFFEE2E2) : Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(isAlert ? Icons.warning_rounded : Icons.check_circle_rounded, color: statusColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 4),
                Text(currentStock, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

