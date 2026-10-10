import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/madrasah_settings_provider.dart';
import '../../core/utils/madrasah_terms.dart';

class AddStudentScreen extends ConsumerStatefulWidget {
  const AddStudentScreen({super.key});

  @override
  ConsumerState<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends ConsumerState<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _guardianPhoneController = TextEditingController();
  final _studentPhoneController = TextEditingController(); // Optional

  String? _selectedClass;
  bool _isLoading = false;

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Typically Madrasah Code would come from Admin's own profile, 
      // but assuming 'MAD-786' as universal for this scope until multi-tenant is fully wired.
      final madrasahCode = 'MAD-786'; 
      
      await FirebaseFirestore.instance.collection('students').add({
        'name': _nameController.text.trim(),
        'roll': _rollController.text.trim(),
        'className': _selectedClass,
        'guardianPhone': _guardianPhoneController.text.trim(),
        'studentPhone': _studentPhoneController.text.trim(),
        'madrasahCode': madrasahCode,
        'createdAt': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception("Database connection timed out! Make sure your device has internet and Firestore Database is created in the Firebase Console.");
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student added successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding student: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final madrasahType = ref.watch(madrasahTypeProvider);
    final classes = MadrasahTerms.getClasses(madrasahType);
    
    // Ensure _selectedClass is valid for the current type, otherwise reset
    if (_selectedClass == null || !classes.contains(_selectedClass)) {
      _selectedClass = classes.isNotEmpty ? classes.first : null;
    }

    return Scaffold(
      backgroundColor: AppTheme.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBrand,
        title: const Text('Add New Student', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_add_alt_1_rounded, size: 60, color: AppTheme.primaryBrand),
              ),
              const SizedBox(height: 32),

              _buildInputField(
                controller: _nameController,
                label: 'Student Name',
                icon: Icons.person_rounded,
                validator: (val) => val == null || val.isEmpty ? 'Please enter student name' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller: _rollController,
                      label: 'Roll / ID',
                      icon: Icons.badge_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedClass,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primaryBrand),
                          items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))).toList(),
                          onChanged: (val) => setState(() => _selectedClass = val),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildInputField(
                controller: _guardianPhoneController,
                label: 'Guardian Phone (For Auto-Approval & SMS)',
                icon: Icons.family_restroom_rounded,
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? 'Required for auto-approval' : null,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                controller: _studentPhoneController,
                label: 'Student Phone (Optional)',
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),

              _isLoading
                  ? Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand))
                  : ElevatedButton(
                      onPressed: _saveStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBrand,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        shadowColor: AppTheme.primaryBrand.withValues(alpha: 0.4),
                      ),
                      child: const Text(
                        'Save Student Record',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(icon, color: AppTheme.primaryBrand.withValues(alpha: 0.7)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}

