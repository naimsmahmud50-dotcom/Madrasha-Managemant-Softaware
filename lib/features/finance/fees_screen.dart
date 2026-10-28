import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeesScreen extends StatefulWidget {
  final String role;
  const FeesScreen({super.key, required this.role});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showGenerateInvoiceSheet() {
    String title = '';
    String subtitle = 'Monthly Tuition Fee';
    double amount = 0;
    String dueDate = '';
    String studentName = '';

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
                    Text('Generate Invoice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                    SizedBox(height: 16),
                    
                    TextField(
                      decoration: InputDecoration(labelText: 'Student Name / Class', border: OutlineInputBorder()),
                      onChanged: (val) => studentName = val,
                    ),
                    SizedBox(height: 12),

                    TextField(
                      decoration: InputDecoration(labelText: 'Invoice Title (e.g., October 2026)', border: OutlineInputBorder()),
                      onChanged: (val) => title = val,
                    ),
                    SizedBox(height: 12),

                    TextField(
                      decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                      onChanged: (val) => subtitle = val,
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Amount (৳)', border: OutlineInputBorder()),
                      onChanged: (val) => amount = double.tryParse(val) ?? 0,
                    ),
                    SizedBox(height: 12),

                    TextField(
                      decoration: InputDecoration(labelText: 'Due Date', border: OutlineInputBorder()),
                      onChanged: (val) => dueDate = val,
                    ),
                    
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (title.isEmpty || amount <= 0 || dueDate.isEmpty) return;

                          await FirebaseFirestore.instance.collection('invoices').add({
                            'studentName': studentName.isEmpty ? 'All Students' : studentName,
                            'title': title,
                            'subtitle': subtitle,
                            'amount': amount,
                            'dueDate': dueDate,
                            'status': 'PENDING',
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text('Generate Invoice', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  void _payInvoice(String docId) async {
    // In a real app, this would redirect to bKash/Nagad gateway
    await FirebaseFirestore.instance.collection('invoices').doc(docId).update({
      'status': 'PAID',
      'paidAt': FieldValue.serverTimestamp(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Successful! (Mock)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'Admin';
    final isTeacher = widget.role == 'Teacher';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text((isAdmin || isTeacher) ? 'Finance Dashboard' : 'My Fees & Payments', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primaryBrand,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('invoices').orderBy('createdAt', descending: true).limit(50).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allInvoices = snapshot.data?.docs ?? [];
          
          if (isAdmin || isTeacher) {
            return _buildAdminFinanceDashboard(allInvoices);
          } else {
            return _buildStudentFeesDashboard(allInvoices);
          }
        }
      ),
      floatingActionButton: (isAdmin || isTeacher)
          ? FloatingActionButton.extended(
              onPressed: _showGenerateInvoiceSheet,
              backgroundColor: Colors.green.shade600,
              icon: Icon(Icons.add_rounded, color: Colors.white),
              label: Text('Generate Invoice', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildAdminFinanceDashboard(List<QueryDocumentSnapshot> invoices) {
    double totalCollected = 0;
    double totalPending = 0;
    
    final paidInvoices = <QueryDocumentSnapshot>[];

    for (var doc in invoices) {
      final data = doc.data() as Map<String, dynamic>;
      final double amt = (data['amount'] ?? 0).toDouble();
      if (data['status'] == 'PAID') {
        totalCollected += amt;
        paidInvoices.add(doc);
      } else {
        totalPending += amt;
      }
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _buildAdminStatCard('Collected', '৳ $totalCollected', Icons.trending_up_rounded, Colors.green.shade600)),
            SizedBox(width: 16),
            Expanded(child: _buildAdminStatCard('Pending Dues', '৳ $totalPending', Icons.warning_rounded, Colors.red.shade600)),
          ],
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('RECENT PAYMENTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          ],
        ),
        SizedBox(height: 12),
        if (paidInvoices.isEmpty)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No payments collected yet.', style: TextStyle(color: Colors.grey)),
          ),
        ...paidInvoices.take(10).map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return _buildRecentPaymentRow(
            data['studentName'] ?? 'Unknown', 
            data['title'] ?? '', 
            '৳${data['amount']}', 
            'Paid'
          );
        }),
      ],
    );
  }

  Widget _buildStudentFeesDashboard(List<QueryDocumentSnapshot> invoices) {
    // In a real app we filter by student UID. Here we show all.
    final pendingInvoices = invoices.where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'PENDING').toList();
    final paidInvoices = invoices.where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'PAID').toList();

    double totalPending = pendingInvoices.fold(0, (acc, doc) => acc + ((doc.data() as Map<String, dynamic>)['amount'] ?? 0));

    return Column(
      children: [
        _buildStudentTopSummary(totalPending),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    labelColor: AppTheme.primaryBrand,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue.shade600,
                    indicatorWeight: 3,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: 'PENDING DUES'),
                      Tab(text: 'PAYMENT HISTORY'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildInvoiceList(pendingInvoices, isPaid: false),
                      _buildInvoiceList(paidInvoices, isPaid: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceList(List<QueryDocumentSnapshot> list, {required bool isPaid}) {
    if (list.isEmpty) {
      return Center(child: Text(isPaid ? 'No payment history.' : 'No pending dues. Great!', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final doc = list[index];
        final data = doc.data() as Map<String, dynamic>;
        return _buildInvoiceCard(
          doc.id,
          data['title'] ?? 'Invoice',
          data['subtitle'] ?? 'Fee',
          '৳${data['amount']}',
          isPaid: isPaid,
          dueDate: data['dueDate'],
        );
      },
    );
  }

  Widget _buildStudentTopSummary(double totalPending) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryBrand,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Outstanding Due', style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('৳', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Text(totalPending.toStringAsFixed(0), style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
              Text('.00', style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(String docId, String title, String subtitle, String amount, {required bool isPaid, String? dueDate}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: Offset(0, 4))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                  SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green.shade600.withValues(alpha: 0.1) : Colors.red.shade600.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPaid ? 'PAID' : 'DUE',
                  style: TextStyle(
                    color: isPaid ? Colors.green.shade600 : Colors.red.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isPaid && dueDate != null)
                    Text('Due Date: $dueDate', style: TextStyle(fontSize: 12, color: Colors.red.shade600, fontWeight: FontWeight.w600)),
                  if (isPaid)
                    Text('Paid Successfully', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                ],
              ),
              ),
              Text(amount, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primaryBrand)),
            ],
          ),
          if (!isPaid) ...[
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _payInvoice(docId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Pay Now', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildAdminStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 20, offset: Offset(0, 10))],
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primaryBrand)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRecentPaymentRow(String name, String sClass, String amount, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade600.withValues(alpha: 0.1),
            child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(sClass, style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.primaryBrand)),
              Text(time, style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}


