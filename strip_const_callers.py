import os
import re

files_to_strip = [
    'lib/main.dart',
    'lib/features/dashboard/app_menu_screen.dart',
    'lib/features/operations/operations_screen.dart',
    'lib/features/people/directory_screen.dart',
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
