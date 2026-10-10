import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/madrasah_settings_provider.dart';

class SystemSettingsScreen extends ConsumerWidget {
  const SystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentType = ref.watch(madrasahTypeProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('System Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primaryBrand,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('MADRASAH TYPE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          _buildOption(
            context: context,
            title: 'Qawmi Madrasah',
            subtitle: 'Uses terms like Jamaat, Marhala, Takmil.',
            isSelected: currentType == MadrasahType.qawmi,
            onTap: () => ref.read(madrasahTypeProvider.notifier).setType(MadrasahType.qawmi),
          ),
          const SizedBox(height: 12),
          _buildOption(
            context: context,
            title: 'Alia Madrasah',
            subtitle: 'Uses terms like Class, Ibtedayi, Dakhil, Alim.',
            isSelected: currentType == MadrasahType.alia,
            onTap: () => ref.read(madrasahTypeProvider.notifier).setType(MadrasahType.alia),
          ),
          const SizedBox(height: 12),
          _buildOption(
            context: context,
            title: 'Both (Hybrid)',
            subtitle: 'Supports both Qawmi & Alia structures simultaneously.',
            isSelected: currentType == MadrasahType.both,
            onTap: () => ref.read(madrasahTypeProvider.notifier).setType(MadrasahType.both),
          ),
          const SizedBox(height: 32),
          Text('DATABASE SYNC', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.green.shade600.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(Icons.cloud_sync_rounded, color: Colors.green.shade600),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cloud Firestore', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Connected & Syncing', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('Verify'))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOption({required BuildContext context, required String title, required String subtitle, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBrand.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppTheme.primaryBrand : Colors.grey.shade200, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppTheme.primaryBrand : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isSelected ? AppTheme.primaryBrand : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

