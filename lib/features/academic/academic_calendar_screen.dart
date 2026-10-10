import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AcademicCalendarScreen extends StatefulWidget {
  const AcademicCalendarScreen({super.key});

  @override
  State<AcademicCalendarScreen> createState() => _AcademicCalendarScreenState();
}

class _AcademicCalendarScreenState extends State<AcademicCalendarScreen> {
  int _selectedDate = 24; // Mock selected date
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8), // Soft Pink Background
      appBar: AppBar(
        title: const Text('Events & Calendar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFFEC4899), // Pink 500
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarHeader(),
          _buildFilterChips(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('UPCOMING IN SEPTEMBER', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF9D174D), letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  _buildEventCard(
                    date: '25',
                    month: 'SEP',
                    title: '1st Term Examination Begins',
                    subtitle: 'All Jamats (Classes)',
                    type: 'Academic',
                    typeColor: Colors.blue.shade600,
                    icon: Icons.menu_book_rounded,
                  ),
                  _buildEventCard(
                    date: '28',
                    month: 'SEP',
                    title: 'Parent-Teacher Meeting',
                    subtitle: 'Maktab & Hifz Department',
                    type: 'Meeting',
                    typeColor: AppTheme.primaryBrand,
                    icon: Icons.groups_rounded,
                  ),
                  const SizedBox(height: 24),
                  const Text('NEXT MONTH (OCTOBER)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF9D174D), letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  _buildEventCard(
                    date: '12',
                    month: 'OCT',
                    title: 'Annual Dastarbandi & Jalsha',
                    subtitle: 'Grand ceremony for Hifz completion',
                    type: 'Event',
                    typeColor: Colors.green.shade600,
                    icon: Icons.celebration_rounded,
                  ),
                  _buildEventCard(
                    date: '20',
                    month: 'OCT',
                    title: 'Autumn Vacation Starts',
                    subtitle: 'Madrasah closed for 5 days',
                    type: 'Holiday',
                    typeColor: Colors.orange.shade500,
                    icon: Icons.event_busy_rounded,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [BoxShadow(color: const Color(0xFFEC4899).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))],
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('September 2026', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Rabi ul Awwal 1448', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 85,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 30,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final date = index + 1;
                final isSelected = date == _selectedDate;
                final dayName = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date % 7];
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? Colors.white : Colors.transparent),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dayName, style: TextStyle(color: isSelected ? const Color(0xFFBE185D) : Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('$date', style: TextStyle(color: isSelected ? const Color(0xFFBE185D) : Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Academic', 'Meeting', 'Holiday', 'Event'];
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : const Color(0xFF831843))),
              selected: isSelected,
              onSelected: (selected) => setState(() => _selectedFilter = filter),
              selectedColor: const Color(0xFFDB2777),
              backgroundColor: const Color(0xFFFCE7F3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.transparent)),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCard({
    required String date,
    required String month,
    required String title,
    required String subtitle,
    required String type,
    required Color typeColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFFFBCFE8).withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 8))],
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          // Date Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F3), // Light Pink
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFBE185D))),
                Text(month, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9D174D))),
              ],
            ),
          ),
          
          // Details Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(type, style: TextStyle(color: typeColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      ),
                      Icon(icon, color: typeColor.withValues(alpha: 0.5), size: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

