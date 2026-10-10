import re
with open('lib/features/academic/marksheet_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('child: const Row(', 'child: Row(')

with open('lib/features/academic/marksheet_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
