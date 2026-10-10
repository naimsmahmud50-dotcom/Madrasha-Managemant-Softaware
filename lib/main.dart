import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/hifz/hifz_screen.dart';
import 'features/result/result_screen.dart';
import 'features/operations/operations_screen.dart';
import 'features/finance/finance_screen.dart';
import 'features/security/security_settings_screen.dart';
import 'features/notifications/notification_center_screen.dart';
import 'features/ai/ai_assistant_screen.dart';
import 'features/privacy/privacy_dsr_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ProviderScope(
      child: MadrasahApp(),
    ),
  );
}

class MadrasahApp extends StatelessWidget {
  MadrasahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madrasah Management Platform',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HifzTrackingScreen(role: 'Admin'),
    ResultScreen(role: 'Admin'),
    FinanceScreen(),
    OperationsScreen(),
    AiAssistantScreen(),
    NotificationCenterScreen(),
    SecuritySettingsScreen(),
    PrivacyDsrScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Hifz'),
    BottomNavigationBarItem(icon: Icon(Icons.grading_rounded), label: 'Results'),
    BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Finance'),
    BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings_rounded), label: 'Ops'),
    BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'AI'),
    BottomNavigationBarItem(icon: Icon(Icons.notifications_active_rounded), label: 'Alerts'),
    BottomNavigationBarItem(icon: Icon(Icons.security_rounded), label: 'Security'),
    BottomNavigationBarItem(icon: Icon(Icons.gavel_rounded), label: 'Privacy'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.primaryBrand,
        selectedItemColor: AppTheme.accentGold,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        items: _navItems,
      ),
    );
  }
}

