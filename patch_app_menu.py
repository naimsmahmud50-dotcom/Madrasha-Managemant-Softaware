import os
import re

path = 'lib/features/dashboard/app_menu_screen.dart'.replace('/', '\\')
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# find: Text(\n  title,\n  style: TextStyle(
# and wrap it with Expanded
new_content = re.sub(
    r'(Text\(\s*title,\s*style: TextStyle\([\s\S]*?,\s*\),)',
    r'Expanded(child: \1)',
    content
)

with open(path, 'w', encoding='utf-8') as f:
    f.write(new_content)
print("Patched app_menu_screen.dart")
