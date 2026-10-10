import os
import re

for root, _, files in os.walk('lib'):
    for file in files:
        if not file.endswith('.dart'): continue
        path = os.path.join(root, file)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            # find Row(...) where Column is a direct child
            # this is easier: just search for '          Column(' or similar where it's indented directly under children
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if 'Row(' in line:
                    # check next few lines for 'Column('
                    for j in range(1, 10):
                        if i+j >= len(lines): break
                        subline = lines[i+j]
                        if 'Expanded(' in subline: break # safe
                        if 'Column(' in subline:
                            # Is it a direct child?
                            # Check if the line above is children: [ or just previous elements
                            print(f"Possible missing Expanded in {path}:{i+1} -> {subline.strip()}")
                            break
