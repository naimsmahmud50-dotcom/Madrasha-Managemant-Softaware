import os
import re

for root, _, files in os.walk('lib/features'):
    for file in files:
        if not file.endswith('.dart'): continue
        path = os.path.join(root, file)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            matches = re.finditer(r'Row\s*\([\s\S]*?children:\s*\[([\s\S]*?)\]', content)
            for m in matches:
                children = m.group(1)
                # Find Rows that have Text without Expanded/Flexible
                if 'Text(' in children and 'Expanded(' not in children and 'Flexible(' not in children:
                    # Let's skip very short texts if possible, or just log the file and excerpt
                    # to see where the problem might be.
                    print(f"[{file}] \n{children.strip()[:150]}")
