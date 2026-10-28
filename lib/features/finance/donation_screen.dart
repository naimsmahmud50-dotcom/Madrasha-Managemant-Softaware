import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 50
      appBar: AppBar(
        title: Text('Donation & Zakat', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Color(0xFF047857), // Emerald 700
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderStats(),
            SizedBox(height: 24),
            _buildActionButtons(context),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FUND CATEGORIES', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2)),
                ],
              ),
            ),
            SizedBox(height: 12),
            _buildFundCategories(),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('RECENT DONATIONS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2)),
                ],
              ),
            ),
            SizedBox(height: 12),
            _buildRecentDonationsList(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStats() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF047857),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Color(0xFF047857).withValues(alpha: 0.3), blurRadius: 15, offset: Offset(0, 5))],
      ),
      child: Column(
        children: [
          Text('Total Ramadan Collection', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Text('৳ 12,50,000', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildMiniStatCard('Online Pay', '৳ 3.5L', Icons.account_balance_rounded),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildMiniStatCard('Cash/Hand', '৳ 9.0L', Icons.payments_rounded),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(String title, String amount, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
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

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: BounceWrapper(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening New Receipt Form...')));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green.shade700, Colors.green.shade600]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.green.shade600.withValues(alpha: 0.3), blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_card_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('New Receipt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: BounceWrapper(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening Donor List...')));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade700.withValues(alpha: 0.3)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.groups_rounded, color: Colors.green.shade700, size: 20),
                    SizedBox(width: 8),
                    Text('Donors', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundCategories() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFundCard('Lillah Boarding', '৳ 5,20,000', Color(0xFF0284C7)),
          _buildFundCard('Zakat Fund', '৳ 4,80,000', Colors.orange.shade600),
          _buildFundCard('Sadaqah', '৳ 1,50,000', AppTheme.primaryBrand),
          _buildFundCard('Mosque Fund', '৳ 1,00,000', Colors.green.shade700),
        ],
      ),
    );
  }

  Widget _buildFundCard(String title, String amount, Color color) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.account_balance_wallet_rounded, color: color, size: 20),
          ),
          Spacer(),
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
          SizedBox(height: 4),
          Text(amount, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildRecentDonationsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildDonationTile('Al-Haj Abdur Rahman', 'Zakat Fund • Cash', '৳ 50,000', 'Today, 10:30 AM', Colors.orange.shade600),
          _buildDonationTile('Anonymous Donor', 'Lillah Boarding • bKash', '৳ 5,000', 'Yesterday, 02:15 PM', Color(0xFF0284C7)),
          _buildDonationTile('Hafiz Zubair Ahmed', 'Sadaqah • Bank Transfer', '৳ 10,000', '20 Sept 2026', AppTheme.primaryBrand),
          _buildDonationTile('M/S Enterprise', 'Mosque Construction • Check', '৳ 1,00,000', '18 Sept 2026', Colors.green.shade700),
        ],
      ),
    );
  }

  Widget _buildDonationTile(String donor, String details, String amount, String date, Color typeColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.volunteer_activism_rounded, color: typeColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(donor, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 4),
                Text(details, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
              SizedBox(height: 4),
              Text(date, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
            ],
          )
        ],
      ),
    );
  }
}

