# Phase 2 Implementation Plan

## 1. Architecture Approach
- **State Management:** Riverpod 2.0 Notifier for localized state (e.g., HostelNotifier, AssignmentNotifier).
- **Database (Cloud):** Firestore collections: `hostel_rooms`, `matbakh_menu`, `assignments`, `student_guardian_links`.
- **Database (Local):** Drift tables for offline caching of assignments and menu.

## 2. Module Breakdown
### A. Assignments Module (`lib/features/academic/assignment_screen.dart`)
- **Teacher View:** Add Assignment FAB (Title, Due Date, PDF/Link attachment).
- **Student View:** Stream of assignments for their class. Submit assignment UI.
- **Admin View:** Global view of all assignments.

### B. Hostel & Dormitory (`lib/features/hostel/hostel_screen.dart`)
- **Admin:** UI to add rooms and allocate students.
- **Student:** View assigned room, bed number, and floor.

### C. Guardian Profile Linker (`lib/features/dashboard/guardian_dashboard.dart`)
- Add a dropdown or modal to switch between linked student profiles.
- Firestore structure: Guardian doc contains `linked_student_ids` [array].

## 3. Testing Strategy (`/tdd-workflow`)
- Unit tests for Riverpod providers to ensure state mutation is correct.
- Widget tests for role-based UI rendering (Admin vs Student).
- Build tests (`flutter build apk`) and lint checks (`flutter analyze`) after every step.
