import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_theme.dart';

import 'identity_verification_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _codeController = TextEditingController(); 

  String _selectedRole = 'Student';
  final List<String> _roles = ['Teacher', 'Student', 'Guardian'];

  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (_phoneController.text.isEmpty || _codeController.text.isEmpty || _pinController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields properly.')));
      return;
    }
    
    if (_pinController.text != _confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PINs do not match! Please check again.')));
      return;
    }

    setState(() => _isLoading = true);

    String rawPhone = _phoneController.text.trim();
    if (rawPhone.startsWith('0')) {
      rawPhone = rawPhone.substring(1); 
    }
    
    final loginPhone = _phoneController.text.trim();
    final fakeEmail = '$loginPhone@madrasha.com';
    final pinPassword = _pinController.text.trim();

    try {
      final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: fakeEmail, 
        password: pinPassword
      );
      
      final user = authResult.user;

      if (user != null) {
        String status = 'Pending';
        
        try {
          final querySnapshot = await FirebaseFirestore.instance
              .collection('students')
              .where('guardianPhone', isEqualTo: loginPhone)
              .limit(1)
              .get();
              
          final querySnapshot2 = await FirebaseFirestore.instance
              .collection('students')
              .where('studentPhone', isEqualTo: loginPhone)
              .limit(1)
              .get();
              
          if (querySnapshot.docs.isNotEmpty || querySnapshot2.docs.isNotEmpty) {
            status = 'Approved'; 
          }
        } catch (e) {
          debugPrint("Auto-approval check failed: $e");
        }
        
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'phone': loginPhone,
          'role': _selectedRole,
          'madrasahCode': _codeController.text.trim(),
          'status': status,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          setState(() => _isLoading = false);
          
          if (status == 'Approved') {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Registration Successful!'),
                content: const Text('Your number is verified in our database. You are approved automatically and connected!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); 
                      Navigator.pop(context); 
                    },
                    child: const Text('OK, Go to Login'),
                  ),
                ],
              ),
            );
          } else {
            if (_selectedRole == 'Teacher') {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Registration Sent'),
                  content: const Text('Your account is Pending Approval. The admin will verify your identity and approve your account.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); 
                        Navigator.pop(context); 
                      },
                      child: const Text('OK, Go to Login'),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => IdentityVerificationScreen(
                    uid: user.uid,
                    phone: loginPhone,
                    role: _selectedRole,
                  ),
                ),
              );
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An account already exists for this phone number.')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Error: ${e.message}')));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBrand,
        title: const Text('New Registration', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.how_to_reg_rounded, size: 80, color: AppTheme.primaryBrand),
            const SizedBox(height: 24),
            
            _buildTextField(
              controller: _codeController,
              hint: 'Madrasah Code (e.g. MAD-786)',
              icon: Icons.qr_code_rounded,
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRole,
                  isExpanded: true,
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (val) => setState(() => _selectedRole = val!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              hint: 'Phone Number (e.g. 01700000000)',
              icon: Icons.phone_android_rounded,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _pinController,
              hint: 'Create a 6-digit PIN',
              icon: Icons.lock_outline_rounded,
              isPassword: true,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _confirmPinController,
              hint: 'Confirm your PIN',
              icon: Icons.lock_rounded,
              isPassword: true,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            _isLoading
                ? Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand))
                : ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBrand,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primaryBrand),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}

