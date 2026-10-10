import os
import re

files_to_strip = [
    'lib/core/theme/app_theme.dart',
    'lib/features/academic/live_class_screen.dart',
    'lib/features/academic/tarbiyah_screen.dart',
    'lib/features/admin/user_approval_screen.dart',
    'lib/features/ai/ai_assistant_screen.dart',
    'lib/features/communications/ptm_screen.dart',
    'lib/features/config/madrasah_config_screen.dart',
    'test/widget_test.dart',
]

# Ensure correct slashes
files_to_strip = [f.replace('\\', '/') for f in files_to_strip]

for filepath in set(files_to_strip):
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        content = re.sub(r'\bconst\s+([A-Z\[\{])', r'\1', content)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Stripped const from {filepath}")
