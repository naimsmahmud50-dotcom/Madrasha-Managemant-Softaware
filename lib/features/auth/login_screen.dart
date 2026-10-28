import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard/admin_dashboard.dart';
import '../dashboard/main_layout.dart';
import '../dashboard/teacher_dashboard.dart';
import '../dashboard/guardian_dashboard.dart';
import '../dashboard/student_dashboard.dart';
import 'registration_screen.dart';
import 'forgot_pin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;
  
  String _selectedRole = 'Admin';
  final List<String> _roles = ['Admin', 'Teacher', 'Guardian', 'Student'];


  Future<void> _handleLogin() async {
    if (_phoneController.text.isEmpty || _pinController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter phone and PIN')));
      return;
    }

    setState(() => _isLoading = true);

    // Development Bypass (Strictly restricted to debug builds only)
    if (kDebugMode && _phoneController.text.trim() == '00000' && _pinController.text.trim() == '123456') {
      setState(() => _isLoading = false);
      if (mounted) {
        Widget targetScreen;
        switch (_selectedRole) {
          case 'Admin': targetScreen = MainLayout(dashboard: AdminDashboard(), role: 'Admin'); break;
          case 'Teacher': targetScreen = MainLayout(dashboard: TeacherDashboard(), role: 'Teacher'); break;
          case 'Guardian': targetScreen = MainLayout(dashboard: GuardianDashboard(), role: 'Guardian'); break;
          case 'Student': targetScreen = MainLayout(dashboard: StudentDashboard(), role: 'Student'); break;
          default: targetScreen = MainLayout(dashboard: AdminDashboard(), role: 'Admin');
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => targetScreen));
      }
      return;
    }

    try {
      final fakeEmail = '${_phoneController.text.trim()}@madrasha.com';
      final pinPassword = _pinController.text.trim();
      
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: fakeEmail, 
        password: pinPassword
      );
      
      final user = authResult.user;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          final status = data['status'] ?? 'Pending';
          final role = data['role'] ?? _selectedRole;
          
          if (status == 'Pending') {
            setState(() => _isLoading = false);
            FirebaseAuth.instance.signOut();
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Account Pending'),
                  content: Text('Your account has not been approved by the Admin yet. Please wait.'),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                ),
              );
            }
            return;
          }

          Widget targetScreen;
          switch (role) {
            case 'Admin': targetScreen = MainLayout(dashboard: AdminDashboard(), role: role); break;
            case 'Teacher': targetScreen = MainLayout(dashboard: TeacherDashboard(), role: role); break;
            case 'Guardian': targetScreen = MainLayout(dashboard: GuardianDashboard(), role: role); break;
            case 'Student': targetScreen = MainLayout(dashboard: StudentDashboard(), role: role); break;
            default: targetScreen = MainLayout(dashboard: AdminDashboard(), role: 'Admin');
          }

          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => targetScreen));
          }
        } else {
          // Admin override or missing doc
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User profile not found in database.')));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Error: Invalid PIN or not registered.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Premium Header (RESTORED)
              Container(
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.mosque_rounded, size: 80, color: AppTheme.accentGold),
                    SizedBox(height: 16),
                    Text(
                      'Madrasah Platform',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enterprise Management System',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Login Form (RESTORED)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Secure Login',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBrand,
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Role Selector
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.08), blurRadius: 15, offset: Offset(0, 5))
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppTheme.primaryBrand.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.admin_panel_settings_rounded, color: AppTheme.primaryBrand, size: 20),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedRole,
                                isExpanded: true,
                                icon: Padding(padding: EdgeInsets.only(right: 8.0), child: Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primaryBrand)),
                                style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                                items: _roles.map((String role) => DropdownMenuItem<String>(value: role, child: Text('Login as $role'))).toList(),
                                onChanged: (String? newValue) => setState(() => _selectedRole = newValue!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Phone Number Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.08), blurRadius: 15, offset: Offset(0, 5))
                        ],
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Phone Number (e.g. 1700000000)',
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppTheme.primaryBrand.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.phone_android_rounded, color: AppTheme.primaryBrand, size: 20),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // PIN Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.08), blurRadius: 15, offset: Offset(0, 5))
                        ],
                      ),
                      child: TextField(
                        controller: _pinController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Secret PIN',
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppTheme.primaryBrand.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.lock_rounded, color: AppTheme.primaryBrand, size: 20),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Premium Floating Login Button
                    _isLoading 
                      ? Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand))
                      : PremiumLoginButton(onTap: _handleLogin),
                    
                    SizedBox(height: 24),
                    
                    // Forgot PIN Option & Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPinScreen())),
                          child: Text(
                            'Forgot PIN?',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Text('|', style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => RegistrationScreen()));
                          },
                          child: Text(
                            'Create Account',
                            style: TextStyle(color: AppTheme.primaryBrand, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24),
                    
                    if (kDebugMode) ...[
                      // --- DEVELOPER BYPASS (DEBUG BUILDS ONLY) ---
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber.shade300, width: 2),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.engineering_rounded, color: Colors.amber, size: 20),
                                SizedBox(width: 8),
                                Text('Developer Security Bypass (Debug Only)', style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: _roles.map((role) {
                                return InkWell(
                                  onTap: () {
                                    Widget targetScreen;
                                    switch (role) {
                                      case 'Admin': targetScreen = MainLayout(dashboard: AdminDashboard(), role: 'Admin'); break;
                                      case 'Teacher': targetScreen = MainLayout(dashboard: TeacherDashboard(), role: 'Teacher'); break;
                                      case 'Guardian': targetScreen = MainLayout(dashboard: GuardianDashboard(), role: 'Guardian'); break;
                                      case 'Student': targetScreen = MainLayout(dashboard: StudentDashboard(), role: 'Student'); break;
                                      default: targetScreen = MainLayout(dashboard: AdminDashboard(), role: 'Admin');
                                    }
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => targetScreen));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
                                    ),
                                    child: Text(role, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryBrand)),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // Fix: Added missing closing bracket for _LoginScreenState

class PremiumLoginButton extends StatefulWidget {
  final VoidCallback onTap;
  const PremiumLoginButton({super.key, required this.onTap});

  @override
  State<PremiumLoginButton> createState() => _PremiumLoginButtonState();
}

class _PremiumLoginButtonState extends State<PremiumLoginButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: _isPressed ? Offset(0, 0) : Offset(0, _floatAnimation.value),
            child: AnimatedScale(
              scale: _isPressed ? 0.95 : 1.0,
              duration: Duration(milliseconds: 100),
              child: Container(
                width: double.infinity,
                height: 60, // Puffed height
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand, // Deep Green
                  borderRadius: BorderRadius.circular(30), // Max curves
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBrand.withValues(alpha: _isPressed ? 0.2 : 0.6),
                      blurRadius: _isPressed ? 10 : 20, // Glows and puffs
                      spreadRadius: _isPressed ? 0 : 2,
                      offset: Offset(0, _isPressed ? 4 : 8),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'ENTER PLATFORM',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



