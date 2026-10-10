import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> upcomingEvents = [
      {
        'title': 'Annual Qiraat Competition',
        'date': '25 Ramadhan, 1447',
        'time': '09:00 AM - 01:00 PM',
        'venue': 'Main Auditorium',
        'image': 'https://images.unsplash.com/photo-1598257006626-48b0c252070d?auto=format&fit=crop&q=80&w=800',
        'color': AppTheme.primaryBrand
      },
      {
        'title': 'Graduation Ceremony (Dastarbandi)',
        'date': '10 Shawwal, 1447',
        'time': '10:00 AM - 04:00 PM',
        'venue': 'Madrasah Open Ground',
        'image': 'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?auto=format&fit=crop&q=80&w=800',
        'color': Colors.orange.shade500
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Events & Competitions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.primaryBrand, // Violet
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: upcomingEvents.length,
        itemBuilder: (context, index) {
          final event = upcomingEvents[index];
          return Container(
            margin: EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: Offset(0, 8))],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Image
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(event['image']), fit: BoxFit.cover),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: event['color'].withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                            child: Text('Upcoming', style: TextStyle(color: event['color'], fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(event['title'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, size: 16, color: Colors.grey.shade600),
                          SizedBox(width: 8),
                          Text(event['date'], style: TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade600),
                          SizedBox(width: 8),
                          Text(event['time'], style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: 16, color: Colors.grey.shade600),
                          SizedBox(width: 8),
                          Text(event['venue'], style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                        ],
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: event['color'],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('RSVP / Participate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

