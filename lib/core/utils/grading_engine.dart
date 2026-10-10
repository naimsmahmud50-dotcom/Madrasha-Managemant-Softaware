import 'package:flutter/material.dart';
import '../providers/madrasah_settings_provider.dart';

class GradingEngine {
  static String getGrade(double marks, MadrasahType type) {
    if (type == MadrasahType.qawmi) {
      if (marks >= 80) return 'Mumtaz';
      if (marks >= 65) return 'Jayyid Jiddan';
      if (marks >= 50) return 'Jayyid';
      if (marks >= 33) return 'Maqbul';
      return 'Rasib';
    } else {
      // Default to Alia/General
      if (marks >= 80) return 'A+';
      if (marks >= 70) return 'A';
      if (marks >= 60) return 'A-';
      if (marks >= 50) return 'B';
      if (marks >= 40) return 'C';
      if (marks >= 33) return 'D';
      return 'F';
    }
  }

  static double getGpa(double marks, MadrasahType type) {
    if (type == MadrasahType.qawmi) return 0.0; // Qawmi uses categories, not GPA
    
    if (marks >= 80) return 5.0;
    if (marks >= 70) return 4.0;
    if (marks >= 60) return 3.5;
    if (marks >= 50) return 3.0;
    if (marks >= 40) return 2.0;
    if (marks >= 33) return 1.0;
    return 0.0;
  }

  static Color getGradeColor(String grade) {
    switch (grade) {
      case 'Mumtaz':
      case 'A+':
        return const Color(0xFF0D5C3A); // Deep Evergreen (Excellent)
      case 'Jayyid Jiddan':
      case 'A':
        return const Color(0xFF16A34A); // Green 600
      case 'Jayyid':
      case 'A-':
      case 'B':
        return const Color(0xFFC5A059); // Gold (Good/Average)
      case 'Maqbul':
      case 'C':
      case 'D':
        return Colors.orange.shade500; // Amber (Pass)
      case 'Rasib':
      case 'F':
        return Colors.red.shade500; // Red (Fail)
      default:
        return const Color(0xFF475569); // Slate 600
    }
  }
}
