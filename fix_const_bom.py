import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    # Remove BOM
    if content.startswith('\ufeff'):
        content = content.replace('\ufeff', '')
    
    # Remove BOM anywhere else just in case
    content = content.replace('\ufeff', '')

    lines = content.split('\n')
    new_lines = []
    for line in lines:
        if '.shade' in line and 'const ' in line:
            # We aggressively remove 'const ' from the line if it has .shade
            # Sometimes it's const Color (which shouldn't happen anymore)
            # Sometimes it's const TextStyle
            line = re.sub(r'\bconst\s+', '', line)
        if 'AppTheme.' in line and 'const ' in line:
            # Also aggressively remove const if it references AppTheme (AppTheme vars are not const)
            line = re.sub(r'\bconst\s+', '', line)
        new_lines.append(line)

    content = '\n'.join(new_lines)

    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed const/BOM in {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

