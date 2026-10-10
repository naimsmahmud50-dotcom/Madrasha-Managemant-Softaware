import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/madrasah_settings_provider.dart';

class ModuleManagerScreen extends ConsumerStatefulWidget {
  const ModuleManagerScreen({super.key});

  @override
  ConsumerState<ModuleManagerScreen> createState() => _ModuleManagerScreenState();
}

class _ModuleManagerScreenState extends ConsumerState<ModuleManagerScreen> {
  // Mock State (In real app, this comes from a Provider/Database)
  final Map<String, bool> _modules = {
    'Hostel & Dormitory': true,
    'Transport System': false,
  };

  @override
  Widget build(BuildContext context) {
    final madrasahType = ref.watch(madrasahTypeProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('App Modules & Features', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.primaryBrand, // Slate 900
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.primaryBrand,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: const Text(
              'Select your Madrasah type to automatically configure relevant modules. You can also toggle optional features.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader('Institution Type'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildTypeTab(context, ref, 'Qawmi', MadrasahType.qawmi, madrasahType),
                      _buildTypeTab(context, ref, 'Alia', MadrasahType.alia, madrasahType),
                      _buildTypeTab(context, ref, 'Both', MadrasahType.both, madrasahType),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Text(
                    'Changing this will instantly show/hide type-specific modules in the menu.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Operations (Optional)'),
                _buildToggle('Hostel & Dormitory', 'Manage seat allocations and boarding.', Icons.hotel_class_rounded, AppTheme.primaryBrand),
                _buildToggle('Transport System', 'Bus routes and student tracking.', Icons.directions_bus_rounded, Colors.orange.shade500),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey.shade600, letterSpacing: 1)),
    );
  }

  Widget _buildToggle(String title, String subtitle, IconData icon, Color iconColor) {
    bool isActive = _modules[title] ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        value: isActive,
        activeTrackColor: Colors.green.shade600.withValues(alpha: 0.3),
        activeThumbColor: Colors.green.shade600,
        onChanged: (value) {
          setState(() {
            _modules[title] = value;
          });
        },
      ),
    );
  }

  Widget _buildTypeTab(BuildContext context, WidgetRef ref, String title, MadrasahType type, MadrasahType currentType) {
    final isSelected = type == currentType;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(madrasahTypeProvider.notifier).setType(type);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppTheme.primaryBrand : Colors.black54,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

