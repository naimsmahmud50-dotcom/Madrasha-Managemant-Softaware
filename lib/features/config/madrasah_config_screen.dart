import '../../core/theme/app_theme.dart';
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class MadrasahConfigScreen extends StatefulWidget {
  const MadrasahConfigScreen({super.key});

  @override
  State<MadrasahConfigScreen> createState() => _MadrasahConfigScreenState();
}

class _MadrasahConfigScreenState extends State<MadrasahConfigScreen> {
  String _selectedStream = 'Qawmi';
  String _gradingSystem = 'Division (1st, 2nd, 3rd)';

  bool _enableHifzTracker = true;
  bool _enableHostel = true;
  bool _enableTransport = false;
  bool _enableOnlineFees = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 50
      appBar: AppBar(
        title: Text(
          'Madrasah Configuration',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF334155), // Slate 700
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEFF6FF), // Blue 50
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFBFDBFE),
                  ), // Blue 200
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Colors.blue.shade700),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Changes here will adapt the entire app\'s UI and features (Blueprint v3.0).',
                        style: TextStyle(
                          color: Color(0xFF1E3A8A),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              _buildSectionTitle(
                'ACADEMIC STREAM',
                Icons.account_balance_rounded,
                Color(0xFF475569),
              ),
              SizedBox(height: 12),
              _buildStreamSelector(),

              SizedBox(height: 24),
              _buildSectionTitle(
                'GRADING SYSTEM',
                Icons.grading_rounded,
                Color(0xFF0EA5E9),
              ),
              SizedBox(height: 12),
              _buildGradingSelector(),

              SizedBox(height: 24),
              _buildSectionTitle(
                'ACTIVE MODULES',
                Icons.toggle_on_rounded,
                Colors.green.shade600,
              ),
              SizedBox(height: 12),
              _buildModuleToggle(
                'Hifz & Maktab Tracker',
                Icons.menu_book_rounded,
                Colors.green.shade700,
                _enableHifzTracker,
                (val) => setState(() => _enableHifzTracker = val),
              ),
              _buildModuleToggle(
                'Hostel & Dormitory',
                Icons.night_shelter_rounded,
                Colors.orange.shade600,
                _enableHostel,
                (val) => setState(() => _enableHostel = val),
              ),
              _buildModuleToggle(
                'Transport Management',
                Icons.directions_bus_rounded,
                Colors.blue.shade700,
                _enableTransport,
                (val) => setState(() => _enableTransport = val),
              ),
              _buildModuleToggle(
                'Online Fee Collection',
                Icons.payments_rounded,
                Color(0xFF7C3AED),
                _enableOnlineFees,
                (val) => setState(() => _enableOnlineFees = val),
              ),

              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBrand,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Configuration saved: $_selectedStream stream active.',
                        ),
                        backgroundColor: Colors.green.shade600,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: Icon(Icons.save_rounded, color: Colors.white),
                  label: Text(
                    'SAVE CONFIGURATION',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildStreamSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _selectedStream == 'Qawmi'
                  ? Colors.green.shade50
                  : Colors.transparent,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),

            child: RadioListTile<String>(
              title: Text(
                'Qawmi Madrasah',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF166534),
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                'Uses Jamat system, Division grading, heavy focus on Hifz.',
                style: TextStyle(color: Color(0xFF14532D)),
              ),
              value: 'Qawmi',
              groupValue: _selectedStream,
              activeColor: Color(0xFF166534),
              onChanged: (value) => setState(() {
                _selectedStream = value!;
                _gradingSystem = 'Division (1st, 2nd, 3rd)';
                _enableHifzTracker = true; // Auto enable for Qawmi
                _enableHostel = true;
              }),
            ),
          ),
          Divider(height: 1),
          Container(
            decoration: BoxDecoration(
              color: _selectedStream == 'Alia'
                  ? Color(0xFFEFF6FF)
                  : Colors.transparent,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),

            child: RadioListTile<String>(
              title: Text(
                'Alia Madrasah',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                'Government curriculum, GPA system, specific class limits.',
                style: TextStyle(color: Color(0xFF1E40AF)),
              ),
              value: 'Alia',
              groupValue: _selectedStream,
              activeColor: Color(0xFF1E3A8A),
              onChanged: (value) => setState(() {
                _selectedStream = value!;
                _gradingSystem = 'GPA (Out of 5.0)';
                _enableHifzTracker = false; // Auto disable for Alia
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradingSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _gradingSystem,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down_circle_rounded,
            color: Color(0xFF0EA5E9),
          ),
          items:
              [
                'Division (1st, 2nd, 3rd)',
                'GPA (Out of 5.0)',
                'GPA (Out of 4.0)',
                'Marks Percentage',
              ].map((String system) {
                return DropdownMenuItem<String>(
                  value: system,
                  child: Text(
                    system,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBrand,
                    ),
                  ),
                );
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _gradingSystem = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildModuleToggle(
    String title,
    IconData icon,
    Color iconColor,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        value: value,
        activeThumbColor: iconColor,
        activeTrackColor: iconColor.withValues(alpha: 0.2),
        onChanged: onChanged,
      ),
    );
  }
}

