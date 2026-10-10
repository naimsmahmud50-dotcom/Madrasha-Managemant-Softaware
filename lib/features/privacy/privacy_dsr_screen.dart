import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PrivacyDsrScreen extends StatelessWidget {
  const PrivacyDsrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Slate 100
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryBrand,
        title: Text('Privacy & Legal Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildComplianceBanner(),
            SizedBox(height: 24),
            Text('DATA SUBJECT REQUESTS (DSR)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
            SizedBox(height: 12),
            _buildActionCard(
              title: 'Export My Data',
              subtitle: 'Download a complete JSON/PDF archive of all platform data.',
              icon: Icons.download_rounded,
              color: Colors.blue.shade600,
            ),
            SizedBox(height: 12),
            _buildActionCard(
              title: 'Request Account Deletion',
              subtitle: 'Initiate a permanent 30-day data purge (PDPA 2026).',
              icon: Icons.delete_forever_rounded,
              color: Colors.red.shade500,
            ),
            SizedBox(height: 24),
            Text('MINOR CONSENT MANAGEMENT', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
            SizedBox(height: 12),
            _buildConsentToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceBanner() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF6EE7B7)),
      ),
      child: Row(
        children: [
          Icon(Icons.gavel_rounded, color: Colors.green.shade700, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PDPA 2026 Compliant', style: TextStyle(color: Colors.green.shade900, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Your data is strictly protected under the Bangladesh Personal Data Protection Act.', style: TextStyle(color: Color(0xFF047857), fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionCard({required String title, required String subtitle, required IconData icon, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade500),
        onTap: () {},
      ),
    );
  }

  Widget _buildConsentToggle() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Photo & Media Usage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
              Switch(
                value: true,
                onChanged: (val) {},
                activeThumbColor: Colors.green.shade600,
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'As the guardian, I consent to the use of the minor student\'s photo in the private madrasah directory. Revoking this will immediately restrict processing.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}

