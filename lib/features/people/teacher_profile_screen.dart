import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Slate 100
      appBar: AppBar(
        title: const Text('Staff Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A), // Deep Indigo
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Displaying Digital ID QR Code...')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDigitalIdCard(context),
            const SizedBox(height: 16),
            _buildInfoSection('Employment Details', [
              _buildInfoRow('Employee ID', 'EMP-1001'),
              _buildInfoRow('Designation', 'Senior Teacher'),
              _buildInfoRow('Department', 'Arabic & Islamic Studies'),
              _buildInfoRow('Date of Joining', '15 Jan 2018'),
              _buildInfoRow('Status', 'Active', valueColor: Colors.green.shade600),
            ]),
            const SizedBox(height: 16),
            _buildInfoSection('Academic Responsibilities', [
              _buildInfoRow('Homeroom Class', 'Class 8 (Mutawassitah)'),
              _buildInfoRow('Subjects Taught', 'Arabic Grammar, Fiqh'),
              _buildInfoRow('Total Classes/Week', '24 Periods'),
            ]),
            const SizedBox(height: 16),
            _buildInfoSection('Personal Information', [
              _buildInfoRow('Blood Group', 'B+ (Positive)', valueColor: Colors.red.shade600),
              _buildInfoRow('Contact Number', '+880 1511-123456'),
              _buildInfoRow('Email', 'abubakr@madrasah.edu.bd'),
              _buildInfoRow('Address', '45, Scholars Avenue, Dhaka'),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalIdCard(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1E3A8A),
      padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          children: [
            // Header of ID Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF172554), // Darker Indigo
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: const Center(
                child: Text('STAFF ID CARD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 13)),
              ),
            ),
            const SizedBox(height: 24),
            // Profile Photo
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1E3A8A), width: 3),
              ),
              child: const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(Icons.person_rounded, size: 50, color: Color(0xFF1E3A8A)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Ustad Abu Bakr', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            Text('Senior Teacher', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            // Details Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIdDetail('ID NO', 'EMP-1001'),
                  _buildIdDetail('BLOOD G.', 'B+'),
                  _buildIdDetail('ISSUED', 'Jan 2026'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Barcode (Simulated)
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/UPC-A-036000291452.svg/320px-UPC-A-036000291452.svg.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            const Text('|| ||| | ||| || ||| | ||| ||', style: TextStyle(letterSpacing: 2, color: Colors.black54, fontSize: 10)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIdDetail(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.1)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor ?? AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

