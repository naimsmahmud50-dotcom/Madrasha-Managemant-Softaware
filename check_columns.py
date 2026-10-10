import os
import re

for root, _, files in os.walk('lib'):
    for file in files:
        if not file.endswith('.dart'): continue
        path = os.path.join(root, file)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            # check if Row has a direct child Column that is not Expanded
            # this is a bit tricky with regex, let's just use string parsing
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if 'Row(' in line and i < len(lines)-10:
                    # check next few lines
                    block = '\n'.join(lines[i:i+15])
                    if 'children: [' in block:
                        if re.search(r'children:\s*\[\s*(?:const\s+)?(?:Icon|CircleAvatar)[^,]+,\s*(?:const\s+)?SizedBox[^,]+,\s*Column\(', block):
                            print(f"Match in {path}:{i+1}")
                            # print(block)
