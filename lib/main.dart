import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firestore Quota Protection: Enable offline persistence and local disk cache
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  runApp(
    const ProviderScope(
      child: MadrasahApp(),
    ),
  );
}

class MadrasahApp extends StatelessWidget {
  const MadrasahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madrasah Management Platform',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
