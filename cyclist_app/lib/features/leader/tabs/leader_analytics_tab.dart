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
          borderColor: AppColors.domainCycling.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.analytics_rounded, size: 18, color: AppColors.domainCycling),
                  SizedBox(width: 8),
                  Text('MUSTER ROLL & ATTENDANCE STATS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statItem('38', 'Total Enrolled', Colors.white),
                  _statItem('34', 'Active (89%)', AppColors.domainCycling),
                  _statItem('32', 'Checked-in (94%)', AppColors.domainMarathon),
                  _statItem('18', 'Finished (53%)', AppColors.warningAmber),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Muster Assembly Progress (Ambazari Gate):', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 0.941,
                  minHeight: 8,
                  backgroundColor: Color(0xFF1E293B),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.domainMarathon),
                ),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('32 of 34 Active Checked-in', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Incident & Route Performance
        GlassCard(
          borderColor: AppColors.domainMarathon.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.health_and_safety_rounded, size: 18, color: AppColors.domainMarathon),
                  SizedBox(width: 8),
                  Text('TEAM SAFETY & INCIDENT LOG', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
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
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: AppColors.domainCycling,
            side: BorderSide(color: AppColors.domainCycling.withOpacity(0.6), width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            shadowColor: AppColors.domainCycling.withOpacity(0.2),
          ),
          icon: const Icon(Icons.download_rounded, size: 20),
          label: const Text('📥 EXPORT TEAM ATTENDANCE CSV', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5)),
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

  Widget _statItem(String val, String label, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: accent, fontFamily: 'monospace')),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _logRow(String label, String value, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accent)),
        ],
      ),
    );
  }
}
