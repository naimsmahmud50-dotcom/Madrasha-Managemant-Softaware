import os
import re

files_to_strip = [
    'lib/features/academic/fatwa_screen.dart',
    'lib/features/communications/events_screen.dart',
    'lib/features/dashboard/main_layout.dart',
    'lib/features/dashboard/placeholder_screen.dart',
    'lib/features/finance/donation_screen.dart',
    'lib/features/finance/expense_tracking_screen.dart',
    'lib/features/finance/payroll_screen.dart',
    'lib/features/finance/zakat_management_screen.dart',
    'lib/features/hifz/hifz_screen.dart',
    'lib/features/hostel/infirmary_screen.dart',
    'lib/features/hostel\matbakh_screen.dart',
    'lib/features/notifications/notification_center_screen.dart',
    'lib/features/operations/admission_screen.dart',
    'lib/features/operations/inventory_screen.dart',
    'lib/features/people/admin_profile_screen.dart',
    'lib/features/people/alumni_network_screen.dart',
    'lib/features/people/guardian_profile_screen.dart',
    'lib/features/people/mpo_tracking_screen.dart',
    'lib/features/people/staff_attendance_screen.dart',
    'lib/features/people/student_profile_screen.dart',
    'lib/features/privacy/privacy_dsr_screen.dart',
    'lib/features/security/gate_pass_screen.dart',
    'lib/features/security/security_settings_screen.dart',
    'lib/features/setup/onboarding_screen.dart',
    'lib/features/transport/transport_tracking_screen.dart',
]

# Ensure correct slashes
files_to_strip = [f.replace('\\', '/') for f in files_to_strip]

for filepath in set(files_to_strip):
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Strip ALL const  (except for const constructor declarations if any)
        # We only want to remove const  in front of widgets or collections.
        # So we can remove const  when it's followed by a capital letter (Widget), 
        # or [ or {.
        content = re.sub(r'\bconst\s+([A-Z\[\{])', r'\1', content)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Stripped const from {filepath}")
