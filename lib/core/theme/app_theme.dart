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
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 4),
        )
      ];

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: softShadow,
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
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
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBrand, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBrand,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(88, 48), // WCAG minimum touch target
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
  final bool isSyncing;
  final VoidCallback? onSync;
  
  const OfflineSyncBanner({
    super.key, 
    required this.pendingItems,
    this.isSyncing = false,
    this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    if (pendingItems == 0) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: AppTheme.accentGold,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 16, color: Color(0xFF422006)), 
              const SizedBox(width: 8),
              Text(
                'Offline: $pendingItems Pending Sync Items',
                style: GoogleFonts.inter(
                  color: const Color(0xFF422006), 
                  fontWeight: FontWeight.w600, 
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (onSync != null)
            InkWell(
              onTap: isSyncing ? null : onSync,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF422006),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isSyncing
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Sync Now',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
