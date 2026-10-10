import os

files_to_check = [
    'lib/features/academic/leave_screen.dart',
    'lib/features/finance/fees_screen.dart',
    'lib/features/academic/marksheet_screen.dart',
    'lib/features/academic/career_placement_screen.dart',
    'lib/features/communications/ptm_screen.dart',
    'lib/features/finance/stipend_management_screen.dart',
    'lib/features/notifications/notification_center_screen.dart',
    'lib/features/people/blood_bank_screen.dart',
    'lib/features/people/staff_attendance_screen.dart',
    'lib/features/result/result_screen.dart',
    'lib/features/security/gate_pass_screen.dart',
    'lib/features/transport/transport_tracking_screen.dart',
    'lib/features/dashboard/app_menu_screen.dart'
]

def wrap_first_child_with_expanded(content):
    # Find mainAxisAlignment: MainAxisAlignment.spaceBetween,\n\s*children: \[
    # then the very next widget that starts with Column( or Row( and wrap it in Expanded(child: ... )
    
    out = []
    lines = content.split('\n')
    i = 0
    while i < len(lines):
        line = lines[i]
        out.append(line)
        if 'mainAxisAlignment: MainAxisAlignment.spaceBetween' in line:
            # Look ahead for children: [
            j = i + 1
            found_children = False
            while j < i + 5 and j < len(lines):
                out.append(lines[j])
                if 'children: [' in lines[j]:
                    found_children = True
                    # The next non-empty line is the target
                    k = j + 1
                    while k < len(lines) and lines[k].strip() == '':
                        out.append(lines[k])
                        k += 1
                    
                    target_line = lines[k]
                    if 'Column(' in target_line or 'Row(' in target_line:
                        # Find indentation
                        indent = len(target_line) - len(target_line.lstrip())
                        # Insert Expanded
                        out.append(' ' * indent + 'Expanded(')
                        out.append(' ' * (indent + 2) + 'child: ' + target_line.lstrip())
                        
                        # Find where this Column/Row ends by counting brackets
                        open_brackets = 0
                        started = False
                        
                        for m in range(k, len(lines)):
                            if m > k:
                                out.append(lines[m])
                            
                            for char in lines[m]:
                                if char == '(': open_brackets += 1
                                elif char == ')': open_brackets -= 1
                                started = True
                            
                            if started and open_brackets == 0:
                                # End of widget! Add closing parenthesis for Expanded
                                out.append(' ' * indent + '),')
                                i = m
                                break
                    else:
                        i = k - 1
                    break
                j += 1
            if found_children:
                pass
        i += 1
    return '\n'.join(out)

for path in files_to_check:
    path = path.replace('/', '\\')
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        new_content = wrap_first_child_with_expanded(content)
        
        if new_content != content:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Patched {path}")
