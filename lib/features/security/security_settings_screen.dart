import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 50
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryBrand, // Slate 900
        title: Text(
          'Security & Configuration',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildSecurityHeader(),
            SizedBox(height: 24),
            Text('AUTHENTICATION & MFA', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
            SizedBox(height: 12),
            _buildSettingCard(
              title: 'Two-Factor Authentication (TOTP)',
              subtitle: 'Mandatory for Admin roles accessing finance.',
              icon: Icons.phonelink_lock,
              iconColor: Colors.blue.shade600,
              trailing: Switch(
                value: true,
                onChanged: (val) {},
                activeThumbColor: Colors.blue.shade600,
              ),
            ),
            SizedBox(height: 12),
            _buildSettingCard(
              title: 'Argon2id Hashing',
              subtitle: 'Enterprise-grade password protection active.',
              icon: Icons.shield_rounded,
              iconColor: Colors.green.shade600,
              trailing: Icon(Icons.check_circle, color: Colors.green.shade600),
            ),
            SizedBox(height: 24),
            Text('DEVICE MANAGEMENT', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
            SizedBox(height: 12),
            _buildSettingCard(
              title: 'Active Sessions',
              subtitle: '3 devices currently logged in.',
              icon: Icons.devices_rounded,
              iconColor: AppTheme.primaryBrand,
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade500),
            ),
            SizedBox(height: 12),
            _buildActionCard(
              title: 'Revoke All Sessions',
              subtitle: 'Instantly invalidates all token families.',
              icon: Icons.phonelink_erase_rounded,
              color: Colors.red.shade500, // Red for dangerous action
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.textPrimary, AppTheme.primaryBrand],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.3), blurRadius: 15, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 32),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Security Policy', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Strict enforcement active across tenant.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSettingCard({required String title, required String subtitle, required IconData icon, required Color iconColor, required Widget trailing}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        trailing: trailing,
      ),
    );
  }

  Widget _buildActionCard({required String title, required String subtitle, required IconData icon, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        onTap: () {
          // Trigger immediate token family invalidation API
        },
      ),
    );
  }
}

