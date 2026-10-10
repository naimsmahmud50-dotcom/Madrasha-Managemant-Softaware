import os
import re

for root, _, files in os.walk('lib'):
    for file in files:
        if not file.endswith('.dart'): continue
        path = os.path.join(root, file)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            # find Row > MainAxisAlignment.spaceBetween > Row
            if 'mainAxisAlignment: MainAxisAlignment.spaceBetween' in content:
                print(f"Check nested Row: {path}")
