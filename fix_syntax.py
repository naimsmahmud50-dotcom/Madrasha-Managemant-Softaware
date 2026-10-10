import os
import re

dashboards = [
    'lib/features/dashboard/admin_dashboard.dart',
    'lib/features/dashboard/teacher_dashboard.dart',
    'lib/features/dashboard/student_dashboard.dart',
    'lib/features/dashboard/guardian_dashboard.dart'
]

for d in dashboards:
    if not os.path.exists(d): continue
    with open(d, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Fix guardian AppTheme.softShadow[0]) -> AppTheme.softShadow[0]
    content = content.replace("AppTheme.softShadow[0])", "AppTheme.softShadow[0]")

    # 2. Fix const AppTheme.textPrimary -> AppTheme.textPrimary
    content = content.replace("const AppTheme.textPrimary", "AppTheme.textPrimary")
    
    # 3. Fix const Colors.grey.shade600 -> Colors.grey.shade600
    content = re.sub(r'const\s+Colors\.([a-zA-Z]+)\.shade([0-9]+)', r'Colors.\1.shade\2', content)

    # 4. Fix const _buildAlertCard(..., Colors.red.shade500) -> _buildAlertCard(..., Colors.red.shade500)
    # Or more generally, if there is a const  before a constructor that now uses a shade, it's invalid.
    # The errors are like const Icon(Icons.xxx, color: Colors.red.shade500)
    content = re.sub(r'const\s+Icon\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'Icon(\1)', content)
    
    # Also const TextStyle(..., color: Colors.blue.shade500)
    content = re.sub(r'const\s+TextStyle\((.*?color:\s*Colors\.[a-zA-Z]+\.shade[0-9]+.*?)\)', r'TextStyle(\1)', content)

    # _buildStatCard(..., const Color(...)) became _buildStatCard(..., Colors.blue.shade600) which is fine.
    
    # Also check const _buildStatCard if any (usually not const).
    
    with open(d, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Fixed syntax in {d}")
