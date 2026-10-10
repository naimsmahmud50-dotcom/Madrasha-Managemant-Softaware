import os
import re

for root, _, files in os.walk('lib/features/dashboard'):
    for file in files:
        if not file.endswith('.dart'): continue
        path = os.path.join(root, file)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            # print all Row widgets to see if there are long texts
            matches = re.finditer(r'Row\s*\([\s\S]*?children:\s*\[([\s\S]*?)\]', content)
            for m in matches:
                children = m.group(1)
                if 'Text(' in children and 'Expanded(' not in children and 'Flexible(' not in children:
                    print(f"[{file}] Potential overflow in Row: \n{children.strip()[:100]}...\n")
