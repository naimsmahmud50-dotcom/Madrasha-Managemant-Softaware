import os
import re

filepath = 'lib/features/finance/fees_screen.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

if 'app_theme.dart' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../core/theme/app_theme.dart';")

replacements = [
    (r'const Color\(0xFFF8FAFC\)', 'Colors.grey.shade50'),
    (r'Color\(0xFFF8FAFC\)', 'Colors.grey.shade50'),
    (r'const Color\(0xFF0F172A\)', 'AppTheme.primaryBrand'),
    (r'Color\(0xFF0F172A\)', 'AppTheme.primaryBrand'),
    (r'const Color\(0xFF2563EB\)', 'Colors.blue.shade600'),
    (r'Color\(0xFF2563EB\)', 'Colors.blue.shade600'),
    (r'const Color\(0xFF3B82F6\)', 'Colors.blue.shade500'),
    (r'Color\(0xFF3B82F6\)', 'Colors.blue.shade500'),
    (r'const Color\(0xFF10B981\)', 'Colors.green.shade600'),
    (r'Color\(0xFF10B981\)', 'Colors.green.shade600'),
    (r'const Color\(0xFFEF4444\)', 'Colors.red.shade600'),
    (r'Color\(0xFFEF4444\)', 'Colors.red.shade600'),
    (r'const Color\(0xFFE11D48\)', 'Colors.red.shade600'),
    (r'Color\(0xFFE11D48\)', 'Colors.red.shade600'),
    (r'Color\(0xFF1E293B\)', 'AppTheme.textPrimary'),
    (r'Color\(0xFF64748B\)', 'Colors.grey.shade600'),
    (r'Color\(0xFF94A3B8\)', 'Colors.grey.shade500'),
]

for old, new in replacements:
    content = re.sub(old, new, content)

# Fix const evaluation errors
content = re.sub(r'const\s+TextStyle\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'TextStyle(\1)', content)
content = re.sub(r'const\s+Icon\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'Icon(\1)', content)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
