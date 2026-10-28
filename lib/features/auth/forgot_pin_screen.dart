import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/bounce_wrapper.dart';

class ForgotPinScreen extends StatefulWidget {
  const ForgotPinScreen({super.key});

  @override
  State<ForgotPinScreen> createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends State<ForgotPinScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitted = false;

  Future<void> _submitRequest() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 11) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 11-digit phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('pin_reset_requests').add({
        'phone': phone,
        'status': 'pending',
        'requestedAt': FieldValue.serverTimestamp(),
      });

      setState(() => _isSubmitted = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset PIN'),
      ),
      body: SafeArea(
        child: _isSubmitted ? _buildSuccessView() : _buildRequestForm(),
      ),
    );
  }

  Widget _buildRequestForm() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_reset_rounded, size: 48, color: AppTheme.primaryBrand),
          SizedBox(height: 16),
          Text(
            'Forgot your PIN?',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
          ),
          SizedBox(height: 8),
          Text(
            'Enter your registered phone number to request a PIN reset from the Madrasah administration.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 32),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'e.g., 01712345678',
              prefixIcon: Icon(Icons.phone_android_rounded, color: AppTheme.primaryBrand),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primaryBrand, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 24),
          BounceWrapper(
            onTap: _isLoading ? () {} : _submitRequest,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: _isLoading ? Colors.grey : AppTheme.primaryBrand,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppTheme.softShadow,
              ),
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Request PIN Reset',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_outline_rounded, size: 64, color: Colors.green),
          ),
          SizedBox(height: 24),
          Text(
            'Request Sent!',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
          ),
          SizedBox(height: 12),
          Text(
            'Your PIN reset request for ${_phoneController.text} has been sent to the administration. Please contact your class teacher or principal to get your new temporary PIN.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          SizedBox(height: 32),
          BounceWrapper(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryBrand),
              ),
              child: Center(
                child: Text(
                  'Back to Login',
                  style: TextStyle(
                    color: AppTheme.primaryBrand,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

