import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PayrollScreen extends StatefulWidget {
  final String role;
  const PayrollScreen({super.key, required this.role});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  void _showGeneratePayrollSheet() {
    String staffName = '';
    String roleName = '';
    double baseSalary = 0;
    double deductions = 0;
    String monthStr = 'October 2026';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24, right: 24, top: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                    SizedBox(height: 24),
                    Text('Generate Payslip', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5B21B6))),
                    SizedBox(height: 16),
                    
                    TextField(
                      decoration: InputDecoration(labelText: 'Staff Name', border: OutlineInputBorder()),
                      onChanged: (val) => staffName = val,
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      decoration: InputDecoration(labelText: 'Role (e.g. Senior Ustad)', border: OutlineInputBorder()),
                      onChanged: (val) => roleName = val,
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      decoration: InputDecoration(labelText: 'Month (e.g. October 2026)', border: OutlineInputBorder()),
                      onChanged: (val) => monthStr = val,
                    ),
                    SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Base Salary (৳)', border: OutlineInputBorder()),
                            onChanged: (val) => baseSalary = double.tryParse(val) ?? 0,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Deductions (৳)', border: OutlineInputBorder()),
                            onChanged: (val) => deductions = double.tryParse(val) ?? 0,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBrand,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (staffName.isEmpty || baseSalary <= 0) return;

                          await FirebaseFirestore.instance.collection('staff_payroll').add({
                            'staffName': staffName,
                            'role': roleName,
                            'month': monthStr,
                            'baseSalary': baseSalary,
                            'deductions': deductions,
                            'netPay': baseSalary - deductions,
                            'status': 'Unpaid',
                            'createdAt': FieldValue.serverTimestamp(),
                            // Optional: link to uid if user mapping exists
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text('Generate Payslip', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _markAsPaid(String docId) async {
    await FirebaseFirestore.instance.collection('staff_payroll').doc(docId).update({
      'status': 'Paid',
    });
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked as Paid')));
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'Admin';
    // If not Admin, we should filter. But since auth is mocked mostly, we show everything for demo or filter by a mock name.
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Violet 50
      appBar: AppBar(
        title: Text('Payroll Management', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.primaryBrand, // Violet 700
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('staff_payroll').orderBy('createdAt', descending: true).limit(50).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppTheme.primaryBrand));
          }

          final docs = snapshot.data?.docs ?? [];
          
          double totalPayroll = 0;
          double totalPaid = 0;
          
          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final double netPay = (data['netPay'] ?? 0).toDouble();
            totalPayroll += netPay;
            if (data['status'] == 'Paid') {
              totalPaid += netPay;
            }
          }

          return Column(
            children: [
              if (isAdmin) _buildHeaderStats(totalPayroll, totalPaid),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('STAFF SALARIES', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF5B21B6), letterSpacing: 1.2)),
                    if (isAdmin)
                      TextButton(
                        onPressed: _showGeneratePayrollSheet,
                        child: Text('+ Generate', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: docs.isEmpty 
                  ? Center(child: Text('No payroll records found.', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        return _buildPayrollTile(docs[index].id, data, isAdmin);
                      },
                    ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildHeaderStats(double total, double paid) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryBrand,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.3), blurRadius: 15, offset: Offset(0, 5))],
      ),
      child: Column(
        children: [
          Text('Total Estimated Payroll', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Text('৳ ${total.toStringAsFixed(0)}', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildMiniStatCard('Paid', '৳ ${paid.toStringAsFixed(0)}', Icons.check_circle_rounded, Colors.green.shade600),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildMiniStatCard('Pending', '৳ ${(total - paid).toStringAsFixed(0)}', Icons.pending_actions_rounded, Colors.orange.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              SizedBox(width: 8),
              Text(title, style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 8),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPayrollTile(String docId, Map<String, dynamic> data, bool isAdmin) {
    bool isPaid = data['status'] == 'Paid';
    Color avatarColor = isPaid ? Colors.green.shade600 : AppTheme.primaryBrand;
    String name = data['staffName'] ?? 'Unknown';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isPaid ? Colors.green.shade600.withValues(alpha: 0.3) : Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: avatarColor.withValues(alpha: 0.1), child: Text(name.isNotEmpty ? name[0] : 'S', style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold))),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                      SizedBox(height: 4),
                      Text(data['role'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid ? Colors.green.shade600.withValues(alpha: 0.1) : Colors.orange.shade500.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isPaid ? 'Paid' : 'Unpaid',
                    style: TextStyle(color: isPaid ? Colors.green.shade600 : Colors.orange.shade500, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Base Salary', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    Text('৳ ${data['baseSalary']}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Deductions', style: TextStyle(fontSize: 12, color: Colors.red.shade500)),
                    Text('- ৳ ${data['deductions']}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.red.shade500)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Colors.grey.shade300),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Net Pay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                    Text('৳ ${data['netPay']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF5B21B6))),
                  ],
                ),
                if (isAdmin && !isPaid) ...[
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _markAsPaid(docId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Mark as Paid', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}

