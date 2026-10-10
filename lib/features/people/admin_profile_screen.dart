import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Slate 100
      appBar: AppBar(
        title: Text(
          'Admin Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryBrand, // Slate 900
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Displaying Digital ID QR Code...'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDigitalIdCard(context),
            SizedBox(height: 16),
            _buildInfoSection('Administrative Details', [
              _buildInfoRow('Admin ID', 'ADM-0001'),
              _buildInfoRow('Designation', 'Principal / Muhtamim'),
              _buildInfoRow('Role Level', 'Super Admin'),
              _buildInfoRow('Joined Date', '01 Jan 2010'),
              _buildInfoRow(
                'System Status',
                'Active',
                valueColor: Colors.green.shade600,
              ),
            ]),
            SizedBox(height: 16),
            _buildInfoSection('Key Responsibilities', [
              _buildInfoRow('Department', 'General Administration'),
              _buildInfoRow('Primary Duty', 'Overall Madrasah Operations'),
              _buildInfoRow('Approvals', 'Finance, Routine, HR'),
            ]),
            SizedBox(height: 16),
            _buildInfoSection('Personal Information', [
              _buildInfoRow(
                'Blood Group',
                'O+ (Positive)',
                valueColor: Colors.red.shade600,
              ),
              _buildInfoRow('Contact Number', '+880 1711-000000'),
              _buildInfoRow('Email', 'admin@madrasah.edu.bd'),
              _buildInfoRow('Address', '1, Madrasah Complex, Dhaka'),
            ]),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalIdCard(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.primaryBrand, // Slate 900
      padding: EdgeInsets.only(bottom: 32, left: 16, right: 16),
      child: Container(
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header of ID Card
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.textPrimary, // Slate 800
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  'ADMIN ID CARD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            // Profile Photo
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryBrand, width: 3),
              ),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 50,
                  color: AppTheme.primaryBrand,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Maulana Abdur Rahman',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Principal / Muhtamim',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            SizedBox(height: 24),
            // Details Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIdDetail('ID NO', 'ADM-0001'),
                  _buildIdDetail('BLOOD G.', 'O+'),
                  _buildIdDetail('ROLE', 'Super Admin'),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Barcode (Simulated)
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/UPC-A-036000291452.svg/320px-UPC-A-036000291452.svg.png',
                  ),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 12),
            Text(
              '|| ||| | ||| || ||| | ||| ||',
              style: TextStyle(
                letterSpacing: 2,
                color: Colors.black54,
                fontSize: 10,
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIdDetail(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
                letterSpacing: 1.1,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

