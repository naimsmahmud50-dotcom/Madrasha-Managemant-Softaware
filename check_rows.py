import os
import re

for root, _, files in os.walk('lib'):
    for file in files:
        if not file.endswith('.dart'): continue
        path = os.path.join(root, file)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            # Simple heuristic: find Row( children: [ ... Text( ... ) ... ] ) without Expanded
            if 'Row(' in content and 'Text(' in content:
                print(f"Check: {path}")
