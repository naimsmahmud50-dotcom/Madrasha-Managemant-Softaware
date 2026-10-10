import os
import re

base_path = 'lib/features/dashboard/'
dashboards = ['admin_dashboard.dart', 'teacher_dashboard.dart', 'student_dashboard.dart', 'guardian_dashboard.dart']

for d in dashboards:
    filepath = base_path + d
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Fix the syntax error: [AppTheme.softShadow[0])] -> AppTheme.softShadow
        # Note: AppTheme.softShadow is a List<BoxShadow>
        content = re.sub(r'\[AppTheme\.softShadow\[0\]\)\]', 'AppTheme.softShadow', content)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {d}")
