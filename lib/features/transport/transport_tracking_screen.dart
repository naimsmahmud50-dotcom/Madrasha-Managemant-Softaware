import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TransportTrackingScreen extends StatelessWidget {
  const TransportTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50, // Very light mint/green background
      appBar: AppBar(
        title: Text('School Transport', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.green.shade700, // Emerald 600
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildMapPlaceholder(),
          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 24),
                    _buildDriverInfo(),
                    SizedBox(height: 32),
                    Text('LIVE ROUTE STATUS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green.shade900, letterSpacing: 1.2)),
                    SizedBox(height: 20),
                    _buildRouteTimeline(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.shade100, // Emerald 100
        image: DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'), // Subtle texture for map feel
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulated Route Line
          Positioned(
            top: 50, left: 100, right: 100, bottom: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade700.withValues(alpha: 0.3), width: 4),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          // Pulsing Vehicle Indicator
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade600.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.green.shade700.withValues(alpha: 0.5), blurRadius: 15, spreadRadius: 5)],
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.directions_bus_rounded, color: Colors.white, size: 28),
            ),
          ),
          // Overlay ETA Badge
          Positioned(
            bottom: 60,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.textPrimary, // Slate 800
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule_rounded, color: Color(0xFF34D399), size: 16),
                  SizedBox(width: 8),
                  Text('ETA: 12 Mins', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade50),
        boxShadow: [BoxShadow(color: Colors.green.shade700.withValues(alpha: 0.08), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(color: Colors.green.shade600, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.green.shade100,
              child: Icon(Icons.person_rounded, size: 30, color: Colors.green.shade700),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Abdul Karim', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Text('Bus 04', style: TextStyle(color: Colors.orange.shade600, fontSize: 11, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Text('Vehicle: Dhaka Metro ???-11-2045', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green.shade600, Colors.green.shade700]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.green.shade600.withValues(alpha: 0.3), blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: IconButton(
              icon: Icon(Icons.call_rounded, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteTimeline() {
    return Column(
      children: [
        _buildTimelineStop('Madrasah Campus', 'Departed at 04:00 PM', true, false),
        _buildTimelineStop('Mirpur 10 Circle', 'Passed at 04:15 PM', true, false),
        _buildTimelineStop('Agargaon Metro', 'Current Location', false, true),
        _buildTimelineStop('Dhanmondi 27', 'Your Drop-off (ETA: 4:45 PM)', false, false, isHighlight: true),
        _buildTimelineStop('New Market', 'Final Stop', false, false, isLast: true),
      ],
    );
  }

  Widget _buildTimelineStop(String title, String subtitle, bool isPassed, bool isCurrent, {bool isLast = false, bool isHighlight = false}) {
    Color dotColor = isPassed ? Colors.green.shade600 : (isCurrent ? Colors.orange.shade500 : Colors.grey.shade400);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isPassed || isCurrent ? dotColor : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: dotColor, width: isPassed || isCurrent ? 0 : 3),
                boxShadow: isCurrent ? [BoxShadow(color: dotColor.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 3)] : [],
              ),
              child: isPassed ? Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 50,
                color: isPassed ? Colors.green.shade600 : Colors.grey.shade300,
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 24),
            padding: EdgeInsets.all(isHighlight ? 16 : 0),
            decoration: isHighlight 
                ? BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade600.withValues(alpha: 0.3)),
                  )
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: isHighlight ? Colors.green.shade900 : AppTheme.textPrimary
                )),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(
                  fontSize: 13, 
                  fontWeight: FontWeight.w500, 
                  color: isCurrent ? Colors.orange.shade600 : Colors.grey.shade600
                )),
              ],
            ),
          ),
        )
      ],
    );
  }
}

