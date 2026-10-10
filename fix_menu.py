import re

with open('lib/features/dashboard/app_menu_screen.dart', 'r') as f:
    content = f.read()

# Academic & Learning
content = content.replace("if (role == 'Teacher' || role == 'Student')", "if (role != 'Guardian')")
content = content.replace("if (role == 'Teacher')", "if (role == 'Teacher' || role == 'Admin')")

# Qawmi Specific
content = content.replace("if (role != 'Admin')\n                _MenuRoute(\n                  'Hifz Tracker'", "_MenuRoute(\n                  'Hifz Tracker'")
content = content.replace("if (role != 'Admin')\n                _MenuRoute(\n                  'Tarbiyah (Akhlaq)'", "_MenuRoute(\n                  'Tarbiyah (Akhlaq)'")

# Alia Specific
content = content.replace("if (role != 'Admin')\n                _MenuRoute(\n                  'NCTB Assignments'", "_MenuRoute(\n                  'NCTB Assignments'")

with open('lib/features/dashboard/app_menu_screen.dart', 'w') as f:
    f.write(content)

print("Done")
