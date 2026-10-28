import '../../core/theme/app_theme.dart';
import '../../core/sync_engine/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_menu_screen.dart';
import '../notifications/notification_center_screen.dart';
import '../people/teacher_profile_screen.dart';
import '../people/student_profile_screen.dart';
import '../people/guardian_profile_screen.dart';
import '../people/admin_profile_screen.dart';

class MainLayout extends StatefulWidget {
  final Widget dashboard;
  final String role;

  const MainLayout({super.key, required this.dashboard, required this.role});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _getProfileScreen() {
    switch (widget.role) {
      case 'Student':
        return StudentProfileScreen();
      case 'Guardian':
        return GuardianProfileScreen();
      case 'Admin':
        return AdminProfileScreen();
      case 'Teacher':
      default:
        return TeacherProfileScreen();
    }
  }

  late final List<Widget> _screens = [
    _getProfileScreen(), // Now index 0 is Home/Profile
    AppMenuScreen(role: widget.role),
    NotificationCenterScreen(),
    widget.dashboard, // Now index 3 is Dashboard/Analytics
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, _) {
                final syncState = ref.watch(syncStateProvider);
                return OfflineSyncBanner(
                  pendingItems: syncState.pendingCount,
                  isSyncing: syncState.status == SyncStatus.syncing,
                  onSync: () => ref.read(syncStateProvider.notifier).syncNow(),
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(), // Premium smooth bouncy feel
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: _screens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade600.withValues(alpha: 0.2), // Blue tint
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              );
            }
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
            // Smoothly animate the PageView when tab is tapped
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOutQuart, // Premium animation curve
            );
          },
          backgroundColor: Colors.white,
          elevation: 10,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: Colors.grey.shade600),
              selectedIcon: Icon(Icons.person_rounded, color: Colors.blue.shade700),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.apps_rounded, color: Colors.grey.shade600),
              selectedIcon: Icon(Icons.apps_rounded, color: Colors.blue.shade700),
              label: 'Menu',
            ),
            NavigationDestination(
              icon: Badge(
                child: Icon(Icons.notifications_outlined, color: Colors.grey.shade600),
              ),
              selectedIcon: Badge(
                child: Icon(Icons.notifications_rounded, color: Colors.blue.shade700),
              ),
              label: 'Alerts',
            ),
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: Colors.grey.shade600),
              selectedIcon: Icon(Icons.dashboard_rounded, color: Colors.blue.shade700),
              label: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }
}

