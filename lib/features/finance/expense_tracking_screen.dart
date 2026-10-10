import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class ExpenseTrackingScreen extends StatefulWidget {
  const ExpenseTrackingScreen({super.key});

  @override
  State<ExpenseTrackingScreen> createState() => _ExpenseTrackingScreenState();
}

class _ExpenseTrackingScreenState extends State<ExpenseTrackingScreen> {
  final List<Map<String, dynamic>> _expenses = [
    {
      'title': 'Matbakh Groceries (Rice & Oil)',
      'category': 'Food & Kitchen',
      'amount': 'Ã Â§Â³ 12,500',
      'date': '22 Sept, 2026',
      'hasVoucher': true,
      'color': Colors.orange.shade500,
      'icon': Icons.restaurant_rounded,
    },
    {
      'title': 'Electricity Bill (August)',
      'category': 'Utilities',
      'amount': 'Ã Â§Â³ 8,200',
      'date': '20 Sept, 2026',
      'hasVoucher': true,
      'color': Color(0xFF0EA5E9),
      'icon': Icons.bolt_rounded,
    },
    {
      'title': 'Library Books Maintenance',
      'category': 'Academic',
      'amount': 'Ã Â§Â³ 3,100',
      'date': '18 Sept, 2026',
      'hasVoucher': false,
      'color': AppTheme.primaryBrand,
      'icon': Icons.menu_book_rounded,
    },
    {
      'title': 'Plumbing Repair (Hostel)',
      'category': 'Maintenance',
      'amount': 'Ã Â§Â³ 1,500',
      'date': '15 Sept, 2026',
      'hasVoucher': true,
      'color': Colors.grey.shade600,
      'icon': Icons.plumbing_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 50
      appBar: AppBar(
        title: Text('Expense & Vouchers', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFFDC2626), // Red 600
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: Icon(Icons.picture_as_pdf_rounded), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  TextButton(
                    onPressed: () {},
                    child: Text('This Month', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildExpenseTile(_expenses[index]);
                },
                childCount: _expenses.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Color(0xFFDC2626),
        icon: Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFDC2626), // Red 600
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Text('Total Expense (Sept)', style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 8),
          Text('Ã Â§Â³ 45,300', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          
          // Custom Mini Chart / Progress Breakdown
          Row(
            children: [
              _buildProgressSegment(flex: 40, color: Colors.orange.shade500),
              SizedBox(width: 4),
              _buildProgressSegment(flex: 30, color: Color(0xFF0EA5E9)),
              SizedBox(width: 4),
              _buildProgressSegment(flex: 20, color: AppTheme.primaryBrand),
              SizedBox(width: 4),
              _buildProgressSegment(flex: 10, color: Colors.grey.shade600),
            ],
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildLegend('Food', Colors.orange.shade500),
              _buildLegend('Utilities', Color(0xFF0EA5E9)),
              _buildLegend('Academic', AppTheme.primaryBrand),
              _buildLegend('Others', Colors.grey.shade600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSegment({required int flex, required Color color}) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildExpenseTile(Map<String, dynamic> expense) {
    Color iconColor = expense['color'];
    bool hasVoucher = expense['hasVoucher'];

    return BounceWrapper(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(expense['icon'], color: iconColor, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expense['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(expense['category'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Text(' Ã¢â‚¬Â¢ ', style: TextStyle(color: Colors.grey.shade400)),
                        Text(expense['date'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(expense['amount'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFDC2626))),
                  SizedBox(height: 6),
                  if (hasVoucher)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey.shade300)),
                      child: Row(
                        children: [
                          Icon(Icons.attachment_rounded, size: 10, color: Colors.grey.shade600),
                          SizedBox(width: 2),
                          Text('Voucher', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                        ],
                      ),
                    )
                  else
                    SizedBox(height: 14), // padding to match
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

