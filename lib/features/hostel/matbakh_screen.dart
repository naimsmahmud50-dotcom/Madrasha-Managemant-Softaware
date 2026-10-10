import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/widgets/bounce_wrapper.dart';

class MatbakhScreen extends StatefulWidget {
  final String role;
  const MatbakhScreen({super.key, required this.role});

  @override
  State<MatbakhScreen> createState() => _MatbakhScreenState();
}

class _MatbakhScreenState extends State<MatbakhScreen> {

  void _showUpdateMenuSheet(String currentBreakfast, String currentLunch, String currentDinner) {
    String breakfast = currentBreakfast;
    String lunch = currentLunch;
    String dinner = currentDinner;

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
                    Text('Update Daily Menu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFC2410C))),
                    SizedBox(height: 16),
                    
                    TextField(
                      controller: TextEditingController(text: breakfast),
                      decoration: InputDecoration(labelText: 'Fajr (Breakfast)', border: OutlineInputBorder()),
                      onChanged: (val) => breakfast = val,
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      controller: TextEditingController(text: lunch),
                      decoration: InputDecoration(labelText: 'Zuhr (Lunch)', border: OutlineInputBorder()),
                      onChanged: (val) => lunch = val,
                    ),
                    SizedBox(height: 12),
                    
                    TextField(
                      controller: TextEditingController(text: dinner),
                      decoration: InputDecoration(labelText: 'Maghrib (Dinner)', border: OutlineInputBorder()),
                      onChanged: (val) => dinner = val,
                    ),
                    
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEA580C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final today = DateTime.now().toIso8601String().split('T')[0];
                          await FirebaseFirestore.instance.collection('matbakh_menu').doc('current').set({
                            'date': today,
                            'breakfast': breakfast.isEmpty ? 'Not set' : breakfast,
                            'lunch': lunch.isEmpty ? 'Not set' : lunch,
                            'dinner': dinner.isEmpty ? 'Not set' : dinner,
                            'updatedAt': FieldValue.serverTimestamp(),
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text('Save Menu', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'Admin' || widget.role == 'Teacher';
    
    // Fallback date formatter without intl
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateString = '${now.day} ${months[now.month - 1]} ${now.year}';

    return Scaffold(
      backgroundColor: Color(0xFFFFF7ED), // Very light orange background
      appBar: AppBar(
        title: Text('Matbakh (Dining)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Color(0xFFEA580C), // Deep Orange for food/dining theme
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('matbakh_menu').doc('current').snapshots(),
        builder: (context, snapshot) {
          String breakfast = 'Paratha, Mixed Vegetable, Tea';
          String lunch = 'White Rice, Beef Curry, Daal';
          String dinner = 'White Rice, Fish Curry, Salad';
          
          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            breakfast = data['breakfast'] ?? breakfast;
            lunch = data['lunch'] ?? lunch;
            dinner = data['dinner'] ?? dinner;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isAdmin) _buildMealStatsCard(),
                if (isAdmin) SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("TODAY'S MENU", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFC2410C), letterSpacing: 1.2)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(12)),
                      child: Text(dateString, style: TextStyle(color: Color(0xFFEA580C), fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildMenuCard('Fajr (Breakfast)', breakfast, Icons.wb_twilight_rounded, Colors.orange.shade500),
                _buildMenuCard('Zuhr (Lunch)', lunch, Icons.wb_sunny_rounded, Colors.red.shade500),
                _buildMenuCard('Maghrib (Dinner)', dinner, Icons.nights_stay_rounded, Color(0xFF6366F1)),
                
                if (isAdmin) ...[
                  SizedBox(height: 32),
                  Text("KITCHEN INVENTORY", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFC2410C), letterSpacing: 1.2)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildInventoryItem('Rice', '15 Sacks', 0.8, Colors.green.shade600)),
                      SizedBox(width: 16),
                      Expanded(child: _buildInventoryItem('Meat', '20 KG', 0.3, Colors.red.shade500)),
                      SizedBox(width: 16),
                      Expanded(child: _buildInventoryItem('Oil', '30 Liters', 0.6, Colors.orange.shade500)),
                    ],
                  ),
                  SizedBox(height: 32),
                ]
              ],
            ),
          );
        }
      ),
      floatingActionButton: isAdmin
          ? BounceWrapper(
              onTap: () {
                // Read current state to pass into sheet
                FirebaseFirestore.instance.collection('matbakh_menu').doc('current').get().then((doc) {
                  if (doc.exists) {
                    final data = doc.data() as Map<String, dynamic>;
                    _showUpdateMenuSheet(data['breakfast'] ?? '', data['lunch'] ?? '', data['dinner'] ?? '');
                  } else {
                    _showUpdateMenuSheet('', '', '');
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFC2410C)]),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Color(0xFFEA580C).withValues(alpha: 0.4), blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restaurant_menu_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Update Menu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMealStatsCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Color(0xFFEA580C).withValues(alpha: 0.1), blurRadius: 15, offset: Offset(0, 8))],
        border: Border.all(color: Color(0xFFFFEDD5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(color: Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(16)),
                child: Icon(Icons.people_alt_rounded, color: Color(0xFFEA580C), size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Diners Today', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('345 / 350 Students', style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: Colors.grey.shade100, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSmallStat('On Leave', '5', Icons.event_busy_rounded, Colors.grey.shade600),
              _buildSmallStat('Guests', '12', Icons.card_travel_rounded, Color(0xFF0EA5E9)),
              _buildSmallStat('Staff', '40', Icons.badge_rounded, AppTheme.primaryBrand),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSmallStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
        SizedBox(height: 2),
        Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildMenuCard(String time, String menu, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 6.0),
          child: Text(menu, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildInventoryItem(String title, String qty, double percentage, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade600)),
          SizedBox(height: 8),
          Text(qty, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(10),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

