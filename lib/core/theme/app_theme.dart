import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color primaryBrand = Color(0xFF0D5C3A);
  static Color surfaceBackground = Colors.grey.shade50;
  static Color accentGold = Color(0xFFC5A059);
  static Color errorAlert = Colors.red.shade500;
  static Color textPrimary = AppTheme.primaryBrand;
  static Color textSecondary = Color(0xFF475569);

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: Offset(0, 4),
        )
      ];

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: GoogleFonts.inter().fontFamily,
      primaryColor: primaryBrand,
      scaffoldBackgroundColor: surfaceBackground,
      colorScheme: ColorScheme.light(
        primary: primaryBrand,
        secondary: accentGold,
        error: errorAlert,
        surface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBrand,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBrand,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class OfflineSyncBanner extends StatelessWidget {
  final int pendingItems;
  
  OfflineSyncBanner({super.key, required this.pendingItems});

  @override
  Widget build(BuildContext context) {
    if (pendingItems == 0) return SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: AppTheme.accentGold,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_rounded, size: 16, color: Color(0xFF422006)), 
          SizedBox(width: 8),
          Text(
            'Working Offline - $pendingItems Pending Sync Items',
            style: GoogleFonts.inter(
              color: Color(0xFF422006), 
              fontWeight: FontWeight.w600, 
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
