import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class InfirmaryScreen extends StatefulWidget {
  const InfirmaryScreen({super.key});

  @override
  State<InfirmaryScreen> createState() => _InfirmaryScreenState();
}

class _InfirmaryScreenState extends State<InfirmaryScreen> {
  final List<Map<String, dynamic>> _activePatients = [
    {
      'name': 'Abdullah Al Noman',
      'class': 'Class 8 (Hifz)',
      'symptom': 'High Fever (102Ã‚Â°F) & Cough',
      'admittedAt': 'Today, 08:30 AM',
      'status': 'Resting',
      'severity': 'Moderate',
      'severityColor': Colors.orange.shade500,
    },
    {
      'name': 'Zaid bin Thabit',
      'class': 'Class 6 (General)',
      'symptom': 'Stomach Ache / Food Poisoning',
      'admittedAt': 'Yesterday, 11:00 PM',
      'status': 'Observation',
      'severity': 'Moderate',
      'severityColor': Colors.orange.shade500,
    },
    {
      'name': 'Hasan Mahmud',
      'class': 'Class 9 (Qawmi)',
      'symptom': 'Minor Cut on Right Hand',
      'admittedAt': 'Today, 02:15 PM',
      'status': 'Treated & Discharged',
      'severity': 'Low',
      'severityColor': Colors.green.shade600,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Health & Infirmary', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.red.shade600, // Rose 600
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: Icon(Icons.history_rounded), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Active Cases', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  TextButton(
                    onPressed: () {},
                    child: Text('View Inventory', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildPatientCard(_activePatients[index]);
                },
                childCount: _activePatients.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPatientModal(context),
        backgroundColor: Colors.red.shade600,
        icon: Icon(Icons.local_hospital_rounded, color: Colors.white),
        label: Text('Admit Patient', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard('Sickbeds', '4/10', Icons.bed_rounded)),
              SizedBox(width: 12),
              Expanded(child: _buildStatCard('Given Meds', '12', Icons.medication_rounded)),
              SizedBox(width: 12),
              Expanded(child: _buildStatCard('Critical', '0', Icons.emergency_rounded, isAlert: true)),
            ],
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Doctor Visit Scheduled: Today at 04:00 PM (Dr. Kamrul Hasan - General Physician)',
                    style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {bool isAlert = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: isAlert ? Colors.red.shade600 : Color(0xFF0F766E), size: 28),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isAlert ? Colors.red.shade600 : AppTheme.textPrimary)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    bool isDischarged = patient['status'].contains('Discharged');

    return BounceWrapper(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDischarged ? Colors.green.shade100 : Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: patient['severityColor'].withValues(alpha: 0.1),
                  child: Icon(Icons.person_rounded, color: patient['severityColor']),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(patient['name'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      SizedBox(height: 2),
                      Text(patient['class'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: patient['severityColor'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    patient['severity'],
                    style: TextStyle(color: patient['severityColor'], fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: Colors.grey.shade100, height: 1),
            ),
            Row(
              children: [
                Icon(Icons.sick_rounded, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 8),
                Expanded(child: Text(patient['symptom'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)))),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade500),
                    SizedBox(width: 4),
                    Text(patient['admittedAt'], style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
                Text(
                  patient['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDischarged ? Colors.green.shade600 : Colors.red.shade600,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPatientModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(margin: EdgeInsets.only(top: 12, bottom: 8), height: 4, width: 40, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Admit to Infirmary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildInputField('Student Name / Roll', 'Search student...', Icons.search_rounded),
                  SizedBox(height: 16),
                  _buildInputField('Symptoms / Issue', 'E.g., High fever, stomach ache', Icons.sick_rounded),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildInputField('Body Temp (Ã‚Â°F)', 'E.g. 101.5', Icons.thermostat_rounded)),
                      SizedBox(width: 16),
                      Expanded(child: _buildInputField('Blood Pressure', 'E.g. 120/80', Icons.monitor_heart_rounded)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Severity Level', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildSeverityChip('Low', Colors.green.shade600, false)),
                      SizedBox(width: 8),
                      Expanded(child: _buildSeverityChip('Moderate', Colors.orange.shade500, true)),
                      SizedBox(width: 8),
                      Expanded(child: _buildSeverityChip('High', Colors.red.shade600, false)),
                    ],
                  ),
                  SizedBox(height: 32),
                  BounceWrapper(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Patient admitted successfully!'), backgroundColor: Colors.red.shade600));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(16)),
                      child: Text('CONFIRM ADMISSION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
          child: TextField(
            decoration: InputDecoration(
              icon: Icon(icon, color: Colors.grey.shade500, size: 20),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityChip(String label, Color color, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? color : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? color : color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : color, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

