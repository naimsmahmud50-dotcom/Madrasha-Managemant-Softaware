import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppTheme.primaryBrand, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.school_rounded, color: Colors.white, size: 32),
              ),
              SizedBox(height: 24),
              Text(
                'Welcome to\nMadrasah Ecosystem',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand, height: 1.2),
              ),
              SizedBox(height: 12),
              Text(
                'To personalize your dashboard and hide irrelevant features, please select your institution type.',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
              ),
              SizedBox(height: 40),
              
              // Qawmi Option
              _buildSelectionCard(
                title: 'Qawmi Madrasah',
                subtitle: 'Includes Hifz, Darul Ifta, Fuzalaa, Shura Board, and Tarbiyah features.',
                icon: Icons.menu_book_rounded,
                type: 'qawmi',
                color: AppTheme.primaryBrand,
              ),
              
              SizedBox(height: 16),
              
              // Alia Option
              _buildSelectionCard(
                title: 'Alia Madrasah',
                subtitle: 'Includes Board Registration, NCTB Assignments, MPO, and Govt. Stipends.',
                icon: Icons.account_balance_rounded,
                type: 'alia',
                color: Colors.blue.shade700,
              ),
              
              Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedType == null ? null : () {
                    // Navigate to Registration Screen (Next step)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBrand,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text('Continue Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard({required String title, required String subtitle, required IconData icon, required String type, required Color color}) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedType = type),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: isSelected ? 2 : 1),
          boxShadow: [
            if (!isSelected) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? Colors.white : Colors.grey.shade600, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? color : AppTheme.textPrimary)),
                  SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4)),
                ],
              ),
            ),
            SizedBox(width: 12),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? color : Colors.grey.shade300,
            )
          ],
        ),
      ),
    );
  }
}

