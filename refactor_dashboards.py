import os
import re

def humanize_dashboard(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Import AppTheme if not present
    if 'app_theme.dart' not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../core/theme/app_theme.dart';")

    # Replace hardcoded colors with AppTheme or Semantic colors
    replacements = [
        (r'const Color\(0xFFF1F5F9\)', 'Colors.grey.shade50'),
        (r'const Color\(0xFF0F172A\)', 'AppTheme.primaryBrand'),
        (r'Color\(0xFF0F172A\)', 'AppTheme.textPrimary'),
        (r'Color\(0xFF1E293B\)', 'AppTheme.textPrimary'),
        (r'Color\(0xFF64748B\)', 'Colors.grey.shade600'),
        (r'Color\(0xFF94A3B8\)', 'Colors.grey.shade500'),
        (r'Color\(0xFFCBD5E1\)', 'Colors.grey.shade400'),
        (r'const Color\(0xFF2563EB\)', 'Colors.blue.shade600'),
        (r'const Color\(0xFFD97706\)', 'Colors.amber.shade600'),
        (r'Color\(0xFFD97706\)', 'Colors.amber.shade600'),
        (r'const Color\(0xFF059669\)', 'Colors.green.shade600'),
        (r'Color\(0xFF059669\)', 'Colors.green.shade600'),
        (r'const Color\(0xFF10B981\)', 'Colors.green.shade500'),
        (r'Color\(0xFF10B981\)', 'Colors.green.shade500'),
        (r'const Color\(0xFFE11D48\)', 'Colors.red.shade600'),
        (r'Color\(0xFFE11D48\)', 'Colors.red.shade600'),
        (r'const Color\(0xFFEF4444\)', 'Colors.red.shade500'),
        (r'Color\(0xFFEF4444\)', 'Colors.red.shade500'),
        (r'const Color\(0xFF3B82F6\)', 'Colors.blue.shade500'),
        (r'Color\(0xFF3B82F6\)', 'Colors.blue.shade500'),
        (r'const Color\(0xFFF59E0B\)', 'Colors.orange.shade500'),
        (r'Color\(0xFFF59E0B\)', 'Colors.orange.shade500'),
        (r'BoxShadow\(.*?blurRadius:\s*10.*?\)', 'AppTheme.softShadow[0]'),
    ]

    for old, new in replacements:
        content = re.sub(old, new, content)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

base_path = 'lib/features/dashboard/'
dashboards = ['admin_dashboard.dart', 'teacher_dashboard.dart', 'student_dashboard.dart', 'guardian_dashboard.dart']

for d in dashboards:
    if os.path.exists(base_path + d):
        humanize_dashboard(base_path + d)
        print(f"Refactored {d}")

