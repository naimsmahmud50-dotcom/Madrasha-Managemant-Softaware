import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';
import 'student_profile_screen.dart';

class GuardianProfileScreen extends StatelessWidget {
  const GuardianProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Slate 100
      appBar: AppBar(
        title: Text('Guardian Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green.shade900, // Emerald 800
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            SizedBox(height: 16),
            _buildInfoSection('Linked Students (Wards)', [
              _buildStudentTile(context, 'Abdullah Al Mahmud', 'Class 8 (Mutawassitah)', 'STU-0891', Color(0xFF0EA5E9)),
              Divider(height: 1, color: Colors.grey.shade100),
              _buildStudentTile(context, 'Abdur Rahman', 'Class 5 (Ibtidaiyyah)', 'STU-1205', Colors.green.shade600),
            ]),
            SizedBox(height: 16),
            _buildInfoSection('Personal Details', [
              _buildInfoRow('Guardian ID', 'GRD-2023-110'),
              _buildInfoRow('Relation to Student', 'Father'),
              _buildInfoRow('Occupation', 'Businessman'),
              _buildInfoRow('Primary Contact', '+880 1711-000000'),
              _buildInfoRow('Secondary Contact', '+880 1811-000000'),
              _buildInfoRow('Address', '123, Islamic Center Road, Dhaka'),
            ]),
            SizedBox(height: 16),
            _buildInfoSection('Financial Overview', [
              _buildInfoRow('Active Payment Plans', '2 Plans Active'),
              _buildInfoRow('Total Outstanding', '৳ 1,500', valueColor: Colors.red.shade600),
              _buildInfoRow('Next Due Date', '05 Oct 2026', valueColor: Colors.green.shade900),
            ]),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.green.shade900, // Emerald 800
      padding: EdgeInsets.only(bottom: 32, top: 24),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 3),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green.shade100,
              child: Icon(Icons.shield_rounded, size: 50, color: Colors.green.shade900),
            ),
          ),
          SizedBox(height: 16),
          Text('MD. Abdur Rahman', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Color(0xFF34D399).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
            child: Text('Verified Guardian', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6EE7B7))),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTile(BuildContext context, String name, String className, String id, Color avatarColor) {
    return BounceWrapper(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentProfileScreen()));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: avatarColor.withValues(alpha: 0.1),
              child: Text(name.substring(0, 1), style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                        child: Text(id, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                      ),
                      SizedBox(width: 8),
                      Text(className, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
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
            child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.1)),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: Offset(0, 2)),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

