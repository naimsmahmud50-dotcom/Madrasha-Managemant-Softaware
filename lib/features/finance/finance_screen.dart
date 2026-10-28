import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/bounce_wrapper.dart';
import 'donation_screen.dart';
import 'expense_tracking_screen.dart';
import 'payroll_screen.dart';
import 'zakat_management_screen.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 50
      appBar: AppBar(
        title: const Text('Finance & Accounts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        elevation: 0,
        backgroundColor: AppTheme.primaryBrand,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Financial Overview
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.2), blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Balance (Sept 2026)', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    const Text('৳ 14,50,000', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _buildSummaryCard('Total Collection', '৳ 4,20K', Icons.arrow_upward_rounded, Colors.green.shade600)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSummaryCard('Pending Dues', '৳ 1,15K', Icons.warning_rounded, Colors.orange.shade500)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 16,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    _buildQuickAction(context, 'Collect Fee', Icons.payments_rounded, const Color(0xFF0EA5E9), null),
                    _buildQuickAction(context, 'Add Expense', Icons.receipt_long_rounded, Colors.red.shade500, ExpenseTrackingScreen()),
                    _buildQuickAction(context, 'Payroll', Icons.account_balance_rounded, AppTheme.primaryBrand, PayrollScreen(role: 'Admin')),
                    _buildQuickAction(context, 'Donations', Icons.volunteer_activism_rounded, Colors.green.shade600, DonationScreen()),
                    _buildQuickAction(context, 'Zakat/Fund', Icons.mosque_rounded, Colors.green.shade700, ZakatManagementScreen()),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              // Recent Transactions list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    TextButton(
                      onPressed: () {},
                      child: Text('View All', style: TextStyle(color: AppTheme.primaryBrand, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildTransactionTile('Monthly Fee - Abdullah', 'Class 6 - Roll 102', '৳ 1,500', 'Success', true),
                  _buildTransactionTile('Electricity Bill', 'Utility Expenses', '৳ 8,200', 'Expense', false),
                  _buildTransactionTile('Donation - Rahim', 'General Fund', '৳ 5,000', 'Success', true),
                  _buildTransactionTile('Pending Fee - Omar', 'Class 6 - Roll 103', '৳ 1,500', 'Pending', true, isPending: true),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 12),
          Text(amount, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Color color, Widget? targetScreen) {
    return BounceWrapper(
      onTap: () {
        if (targetScreen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening $title module...')));
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(String title, String subtitle, String amount, String status, bool isIncome, {bool isPending = false}) {
    Color statusColor;
    if (isPending) {
      statusColor = Colors.orange.shade500; // Amber
    } else if (isIncome) {
      statusColor = Colors.green.shade600; // Green
    } else {
      statusColor = Colors.red.shade500; // Red
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isPending ? statusColor : AppTheme.textPrimary)),
              const SizedBox(height: 4),
              Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
            ],
          )
        ],
      ),
    );
  }
}

