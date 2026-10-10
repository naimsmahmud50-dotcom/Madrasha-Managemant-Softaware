import os
import re

file_path = 'lib/features/result/result_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace _getGrade and _getGpa with calls to GradingEngine
content = re.sub(
    r'// Helper to calculate Grade from marks.*?return 0\.0;\s*\}',
    '',
    content,
    flags=re.DOTALL
)

# Update _showAddResultSheet signature to accept MadrasahType, wait, no, it can just read ref.read() inside, or we can read it in the onPressed.
# In _showAddResultSheet:
content = re.sub(
    r'void _showAddResultSheet\(\)\s*\{',
    'void _showAddResultSheet() {\n    final madrasahType = ref.read(madrasahTypeProvider);',
    content
)

# Update the calculation in _showAddResultSheet
calc_old = r'''double avgGpa = \(_getGpa\(qM\) \+ _getGpa\(aM\) \+ _getGpa\(mM\)\) / 3\.0;.*?finalGrade = 'D'; \}'''
calc_new = '''double avgGpa = (GradingEngine.getGpa(qM.toDouble(), madrasahType) + GradingEngine.getGpa(aM.toDouble(), madrasahType) + GradingEngine.getGpa(mM.toDouble(), madrasahType)) / 3.0;
                          double avgMarks = total / 3.0;
                          String finalGrade = madrasahType == MadrasahType.qawmi 
                              ? GradingEngine.getGrade(avgMarks, madrasahType) 
                              : GradingEngine.getGrade(avgGpa >= 5.0 ? 80 : (avgGpa >= 4.0 ? 70 : (avgGpa >= 3.5 ? 60 : (avgGpa >= 3.0 ? 50 : (avgGpa >= 2.0 ? 40 : (avgGpa >= 1.0 ? 33 : 0))))), madrasahType);'''

content = re.sub(calc_old, calc_new, content, flags=re.DOTALL)

# Update subjects dict inside _showAddResultSheet
subj_old = r''''subjects': \{
\s*'Quran & Tajweed': \{'marks': qM, 'grade': _getGrade\(qM\)\},
\s*'Arabic Grammar': \{'marks': aM, 'grade': _getGrade\(aM\)\},
\s*'Mathematics': \{'marks': mM, 'grade': _getGrade\(mM\)\},
\s*\}'''
subj_new = ''''subjects': {
                              'Quran & Tajweed': {'marks': qM, 'grade': GradingEngine.getGrade(qM.toDouble(), madrasahType)},
                              'Arabic Grammar': {'marks': aM, 'grade': GradingEngine.getGrade(aM.toDouble(), madrasahType)},
                              'Mathematics': {'marks': mM, 'grade': GradingEngine.getGrade(mM.toDouble(), madrasahType)},
                            }'''
content = re.sub(subj_old, subj_new, content)

# Remove hardcoded colors
content = re.sub(r'const Color\(0xFF8B5CF6\)', 'AppTheme.primaryBrand', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
