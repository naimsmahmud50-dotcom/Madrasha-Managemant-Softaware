import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';
import '../../core/utils/pdf_generator.dart';
import '../../core/theme/app_theme.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Slate 100
      appBar: AppBar(
        title: Text('Digital ID & Certificates', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.primaryBrand, // Slate 900
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.primaryBrand,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.textPrimary, // Slate 800
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton('Digital ID', 0)),
                  Expanded(child: _buildTabButton('Certificates', 1)),
                ],
              ),
            ),
          ),
          Expanded(
            child: _selectedTab == 0 ? _buildDigitalIdView() : _buildCertificatesView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBrand : Colors.transparent, // Blue 500
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.3), blurRadius: 8, offset: Offset(0, 4))] : [],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDigitalIdView() {
    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        Text('FRONT', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 12)),
        SizedBox(height: 12),
        // ID Card Front
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: Offset(0, 10))],
            image: DecorationImage(
              image: NetworkImage('https://www.transparenttextures.com/patterns/white-diamond.png'), // Subtle texture
              opacity: 0.5,
              repeat: ImageRepeat.repeat,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryBrand, Color(0xFF1E3A8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school_rounded, color: Color(0xFFFBBF24), size: 28),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text('MADRASAH AL-NOOR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('Student Identity Card', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 2)),
                  ],
                ),
              ),
              SizedBox(height: 32),
              // Profile Picture
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryBrand, width: 3),
                  boxShadow: [BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.3), blurRadius: 10)],
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=300'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Student Details
              Text('Abdullah Al Mahmud', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand), textAlign: TextAlign.center),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(12)),
                child: Text('Class 8 (Mutawassitah)', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIdField('Roll No', '101'),
                    _buildIdField('Blood Group', 'O+'),
                    _buildIdField('Session', '2026-27'),
                  ],
                ),
              ),
              SizedBox(height: 32), // Replaced Spacer()
              // Footer Barcode
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                color: Colors.grey.shade50,
                child: Column(
                  children: [
                    Icon(Icons.qr_code_2_rounded, size: 40, color: AppTheme.primaryBrand),
                    SizedBox(height: 4),
                    Text('ID: 2026-101-001', style: TextStyle(color: Colors.grey.shade600, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
        
        SizedBox(height: 32),
        
        BounceWrapper(
          onTap: () {
            PdfGenerator.generateAndPrintIdCard(
              studentName: 'Abdullah Al Mahmud',
              studentRoll: '101',
              className: 'Class 8',
              phone: '+8801711000000',
              bloodGroup: 'O+',
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryBrand),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download_rounded, color: AppTheme.primaryBrand),
                SizedBox(width: 8),
                Text('Download PDF', style: TextStyle(color: AppTheme.primaryBrand, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildIdField(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, color: AppTheme.primaryBrand, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCertificatesView() {
    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        _buildCertificateCard(
          title: 'Certificate of Excellence',
          subtitle: 'Hifz Completion (Juz 1-10)',
          date: '15 Sha\'ban 1447 AH',
          color: Colors.green.shade700, // Emerald
        ),
        SizedBox(height: 20),
        _buildCertificateCard(
          title: 'Participation Award',
          subtitle: 'Annual Qira\'at Competition',
          date: '20 Rajab 1447 AH',
          color: Colors.orange.shade600, // Amber
        ),
      ],
    );
  }

  Widget _buildCertificateCard({required String title, required String subtitle, required String date, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: Offset(0, 8))],
        border: Border.all(color: Colors.grey.shade200, width: 2),
      ),
      child: Column(
        children: [
          // Certificate Visual
          Container(
            constraints: BoxConstraints(minHeight: 180),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50, // Off white parchment feel
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_rounded, size: 48, color: color),
                  SizedBox(height: 12),
                  Text(title.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary, letterSpacing: 2), textAlign: TextAlign.center),
                  SizedBox(height: 8),
                  Text(subtitle, style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey.shade600), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          // Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade500),
                    SizedBox(width: 6),
                    Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share_rounded, color: AppTheme.primaryBrand),
                      onPressed: () {},
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(8),
                    ),
                    IconButton(
                      icon: Icon(Icons.download_rounded, color: AppTheme.primaryBrand),
                      onPressed: () {},
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(8),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}





