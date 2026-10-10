import os
import re

color_map = {
    '0xFF0F172A': 'AppTheme.primaryBrand',
    '0xFF1E293B': 'AppTheme.textPrimary',
    '0xFF64748B': 'Colors.grey.shade600',
    '0xFF94A3B8': 'Colors.grey.shade500',
    '0xFFCBD5E1': 'Colors.grey.shade400',
    '0xFFE2E8F0': 'Colors.grey.shade300',
    '0xFFF1F5F9': 'Colors.grey.shade100',
    '0xFFF8FAFC': 'Colors.grey.shade50',
    '0xFF10B981': 'Colors.green.shade600',
    '0xFF059669': 'Colors.green.shade700',
    '0xFF065F46': 'Colors.green.shade900',
    '0xFF3B82F6': 'Colors.blue.shade600',
    '0xFF2563EB': 'Colors.blue.shade700',
    '0xFFD97706': 'Colors.orange.shade600',
    '0xFFF59E0B': 'Colors.orange.shade500',
    '0xFFEF4444': 'Colors.red.shade500',
    '0xFFE11D48': 'Colors.red.shade600',
    '0xFF8B5CF6': 'AppTheme.primaryBrand',
    '0xFF6D28D9': 'AppTheme.primaryBrand',
    '0xFF4C1D95': 'AppTheme.primaryBrand',
    '0xFFC4B5FD': 'Colors.blue.shade200',
    '0xFFF5F3FF': 'Colors.grey.shade50',
    '0xFFF3F4F6': 'Colors.grey.shade100',
    '0xFF9CA3AF': 'Colors.grey.shade500',
    '0xFF374151': 'AppTheme.textPrimary',
    '0xFF111827': 'AppTheme.textPrimary',
    '0xFF0D9488': 'AppTheme.primaryBrand',
    '0xFF000000': 'Colors.black',
    '0xFFFFFFFF': 'Colors.white',
    '0xFFF0FDF4': 'Colors.green.shade50',
    '0xFFD1FAE5': 'Colors.green.shade100',
    '0xFFFEF3C7': 'Colors.orange.shade50',
    '0xFFECFDF5': 'Colors.green.shade50',
}

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    # Replace colors
    for hex_code, replacement in color_map.items():
        content = re.sub(r'const\s+Color\(' + hex_code + r'\)', replacement, content, flags=re.IGNORECASE)
        content = re.sub(r'Color\(' + hex_code + r'\)', replacement, content, flags=re.IGNORECASE)
    
    # Generic replacement for any remaining 0xFF colors to a grey if it's not in the map, 
    # but it's safer to just let them be, or replace with AppTheme.primaryBrand if it looks like primary.
    # We will just fix the const issues.

    content = re.sub(r'const\s+Icon\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'Icon(\1)', content)
    content = re.sub(r'const\s+TextStyle\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'TextStyle(\1)', content)
    content = re.sub(r'const\s+BoxDecoration\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'BoxDecoration(\1)', content)
    content = re.sub(r'const\s+BorderSide\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'BorderSide(\1)', content)
    content = re.sub(r'const\s+LinearGradient\((.*?colors:\s*\[.*?Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'LinearGradient(\1)', content)
    content = re.sub(r'const\s+BoxShadow\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'BoxShadow(\1)', content)

    # Fix generic const with AppTheme variables
    content = re.sub(r'const\s+TextStyle\((.*?color:\s*AppTheme\.[a-zA-Z]+.*?)\)', r'TextStyle(\1)', content)
    content = re.sub(r'const\s+Icon\((.*?color:\s*AppTheme\.[a-zA-Z]+.*?)\)', r'Icon(\1)', content)
    content = re.sub(r'const\s+BoxDecoration\((.*?color:\s*AppTheme\.[a-zA-Z]+.*?)\)', r'BoxDecoration(\1)', content)
    content = re.sub(r'const\s+BorderSide\((.*?color:\s*AppTheme\.[a-zA-Z]+.*?)\)', r'BorderSide(\1)', content)

    if content != original_content:
        # Add import if missing
        if 'AppTheme.' in content and 'app_theme.dart' not in content:
            # simple heuristical import
            content = "import '../../core/theme/app_theme.dart';\n" + content
            
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

