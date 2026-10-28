import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryBrand.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accentGold.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                size: 38,
                color: AppTheme.primaryBrand,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text(actionLabel!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBrand,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
