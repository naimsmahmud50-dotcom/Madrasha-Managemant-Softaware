# Phase 2 Modules Specification
## 1. Overview
This specification covers the remaining features based on the previously provided PDF and project requirements. It strictly adheres to the role-based architecture and offline-first (Drift + Riverpod + Firebase) strategy.

## 2. Outstanding Modules
1. **Hostel & Dormitory Management** (Admin: Allocate Seats, Student: View Seat, Teacher: Supervise)
2. **Matbakh (Dining)** (Manage daily meals, schedules, and food stock)
3. **Assignments (Teacher & Student)** (Teacher uploads assignment, Student views/submits, Admin monitors)
4. **Guardian Multi-Student Linking** (A guardian can link their single phone number to multiple students and switch profiles)

## 3. Core Requirements
- **Data Privacy:** Users must ONLY see data relevant to them (e.g. Student sees their own assignments, Guardian sees their children's data).
- **Design System:** Must use existing premium AppTheme (Indigo primary, White cards, soft shadows).
- **Architecture:** Feature-first folder structure, Riverpod 2.0 State Management.
- **Error Free:** Absolute zero regressions on existing codebase.

## 4. Next Steps
Review this specification. If there are other modules from the PDF that need to be prioritized (e.g. Payroll, Inventory), they will be appended to this spec.
