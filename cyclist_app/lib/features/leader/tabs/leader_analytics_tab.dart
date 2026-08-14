import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class LeaderAnalyticsTab extends StatelessWidget {
  const LeaderAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Muster Roll & Attendance Card
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.analytics_rounded, size: 16, color: AppColors.domainCycling),
                  SizedBox(width: 8),
                  Text('MUSTER ROLL & ATTENDANCE STATS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statItem('38', 'Total Enrolled'),
                  _statItem('34', 'Active Today (89.4%)'),
                  _statItem('32', 'Checked-in (94.1%)'),
                  _statItem('18', 'Finished (52.9%)'),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Muster Check-in Progress (Ambazari Gate):', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 0.941,
                  minHeight: 10,
                  backgroundColor: Color(0xFF1E293B),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.domainMarathon),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('32 of 34 Active Checked-in', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Incident & Route Performance
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.health_and_safety_rounded, size: 16, color: AppColors.domainMarathon),
                  SizedBox(width: 8),
                  Text('TEAM SAFETY & INCIDENT LOG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 12),
              _logRow('🚨 SOS Triggered', '1 (Priya Verma - Heat exhaustion)', AppColors.sosRed),
              _logRow('✅ SOS Resolved', '1 (Hydration support dispatched)', AppColors.domainMarathon),
              _logRow('⚡ Avg Contingent Pace', '18.4 km/h', AppColors.domainCycling),
              _logRow('🔋 Low Battery Alerts (<15%)', '2 Riders', AppColors.warningAmber),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 3. Export CSV Action
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceCard,
            foregroundColor: AppColors.domainCycling,
            side: const BorderSide(color: AppColors.domainCycling),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text('📥 EXPORT TEAM ATTENDANCE CSV', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.domainCycling,
                content: Text('✓ VNIT_Club_Roster_Attendance_2026.csv downloaded to device!'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _statItem(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace')),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _logRow(String label, String value, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accent)),
        ],
      ),
    );
  }
}
