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
          borderColor: AppColors.domainCycling.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.people_alt_rounded, size: 18, color: AppColors.domainCycling),
                  SizedBox(width: 8),
                  Text('DOMAIN PARTICIPATION SUMMARY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metricTile('1,248', 'Total Riders', accent: AppColors.domainCycling),
                  _metricTile('16', 'Sub-Groups', accent: Colors.white),
                  _metricTile('1,020', 'In Groups (81%)', accent: AppColors.domainMarathon),
                  _metricTile('228', 'General Only', accent: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Incident & Safety SLA Metrics
        GlassCard(
          borderColor: AppColors.sosRed.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.health_and_safety_rounded, size: 18, color: AppColors.sosRed),
                  SizedBox(width: 8),
                  Text('EMERGENCY SOS & SLA RESOLUTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metricTile('5', 'Total SOS Today', accent: AppColors.sosRed),
                  _metricTile('4.2m', 'Avg SLA Speed', accent: AppColors.domainMarathon),
                  _metricTile('1', 'Active Escort', accent: AppColors.warningAmber),
                  _metricTile('100%', 'Safety Coverage', accent: AppColors.domainCycling),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 3. Contingent Breakdown by Org Type
        GlassCard(
          borderColor: AppColors.domainProtest.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.pie_chart_rounded, size: 18, color: AppColors.domainProtest),
                  SizedBox(width: 8),
                  Text('CONTINGENT BREAKDOWN (BY ORG TYPE)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
              _progressRow('🎓 College & University Unions', 0.42, '42% (524 pax)', AppColors.domainCycling),
              _progressRow('🏢 Corporate & Workplace Teams', 0.32, '32% (400 pax)', AppColors.domainMarathon),
              _progressRow('🌱 NGOs & Civil Society Fronts', 0.26, '26% (324 pax)', AppColors.domainProtest),
            ],
          ),
        ),

        const SizedBox(height: 20),

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
          label: const Text('📥 DOWNLOAD COMPLETE DOMAIN AUDIT LOG', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5)),
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

  Widget _progressRow(String label, double value, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              Text(percentage, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: const Color(0xFF1E293B),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
