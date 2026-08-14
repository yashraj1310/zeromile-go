import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class AdminAnalyticsTab extends StatelessWidget {
  const AdminAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Domain Participation Summary
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.people_alt_rounded, size: 16, color: AppColors.domainCycling),
                  SizedBox(width: 8),
                  Text('DOMAIN PARTICIPATION SUMMARY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metricTile('1,248', 'Total Riders'),
                  _metricTile('16', 'Sub-Groups'),
                  _metricTile('1,020', 'In Sub-Groups (81.7%)'),
                  _metricTile('228', 'General Only'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Incident & Safety SLA Metrics
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.health_and_safety_rounded, size: 16, color: AppColors.sosRed),
                  SizedBox(width: 8),
                  Text('EMERGENCY SOS & SLA RESOLUTION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metricTile('5', 'Total SOS Today', accent: AppColors.sosRed),
                  _metricTile('4.2m', 'Avg Resolution SLA', accent: AppColors.domainMarathon),
                  _metricTile('1', 'Active Medical Escort', accent: AppColors.warningAmber),
                  _metricTile('100%', 'Safety Coverage', accent: AppColors.domainCycling),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 3. Contingent Breakdown by Org Type
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.pie_chart_rounded, size: 16, color: AppColors.domainProtest),
                  SizedBox(width: 8),
                  Text('CONTINGENT BREAKDOWN (BY ORG TYPE)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 12),
              _progressRow('🎓 College & University Unions', 0.42, '42% (524 pax)', AppColors.domainCycling),
              _progressRow('🏢 Corporate & Workplace Teams', 0.32, '32% (400 pax)', AppColors.domainMarathon),
              _progressRow('🌱 NGOs & Civil Society Fronts', 0.26, '26% (324 pax)', AppColors.domainProtest),
            ],
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceCard,
            foregroundColor: AppColors.domainCycling,
            side: const BorderSide(color: AppColors.domainCycling),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text('📥 DOWNLOAD COMPLETE DOMAIN AUDIT LOG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.domainCycling,
                content: Text('✓ Full domain audit log (GeoJSON + Incident Timestamps) exported.'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _metricTile(String val, String label, {Color accent = Colors.white}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent, fontFamily: 'monospace')),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _progressRow(String label, double value, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              Text(percentage, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: const Color(0xFF1E293B),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
