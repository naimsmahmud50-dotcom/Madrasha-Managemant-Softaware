import os
import re

filepath = 'lib/features/finance/fees_screen.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix const evaluation errors around shade600
content = re.sub(r'const\s+Icon\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'Icon(\1)', content)
content = re.sub(r'const\s+TextStyle\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'TextStyle(\1)', content)
# And if there's just a raw const somewhere else, like const ... Colors...
content = re.sub(r'const\s+BoxDecoration\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'BoxDecoration(\1)', content)

# Check line 256 specifically just in case it's something like const EdgeInsets, no that's fine.
lines = content.split('\n')
for i, line in enumerate(lines):
    if 'shade' in line and 'const ' in line:
        if 'const Color' not in line:
            # removing 'const ' if it causes issues, but it's tricky.
            pass

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
