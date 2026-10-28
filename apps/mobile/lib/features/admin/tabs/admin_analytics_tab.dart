import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class AdminAnalyticsTab extends StatelessWidget {
  const AdminAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // 1. Domain Participation Summary
        GlassCard(
          padding: const EdgeInsets.all(16),
          borderColor: AppColors.royalPurple.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.royalPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.people_alt_rounded, size: 18, color: AppColors.royalPurple),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'EVENT PARTICIPATION & TURNOUT',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _metricTile('1,248', 'Total Registered', accent: AppColors.royalPurple, bgElevated: bgElevated, borderCol: borderCol, textMuted: textMuted)),
                  const SizedBox(width: 8),
                  Expanded(child: _metricTile('16', 'Contingents', accent: textCol, bgElevated: bgElevated, borderCol: borderCol, textMuted: textMuted)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _metricTile('1,020', 'In Contingents (81%)', accent: AppColors.vibrantEmerald, bgElevated: bgElevated, borderCol: borderCol, textMuted: textMuted)),
                  const SizedBox(width: 8),
                  Expanded(child: _metricTile('228', 'General Field', accent: AppColors.solarOrange, bgElevated: bgElevated, borderCol: borderCol, textMuted: textMuted)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Incident & Safety SLA Metrics
        GlassCard(
          padding: const EdgeInsets.all(16),
          borderColor: AppColors.sosRed.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.sosRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.health_and_safety_rounded, size: 18, color: AppColors.sosRed),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'EMERGENCY SOS & SLA RESOLUTION',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _metricTile('5', 'Total SOS Logged', accent: AppColors.sosRed, bgElevated: bgElevated, borderCol: borderCol, textMuted: textMuted)),
                  const SizedBox(width: 8),
                  Expanded(child: _metricTile('4.2m', 'Avg Dispatch Speed', accent: AppColors.vibrantEmerald, bgElevated: bgElevated, borderCol: borderCol, textMuted: textMuted)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _metricTile('1', 'Active Aid Van', accent: AppColors.sunnyGold, bgElevated: bgElevated, borderCol: borderCol, textMuted: textMuted)),
                  const SizedBox(width: 8),
                  Expanded(child: _metricTile('100%', 'Medical Coverage', accent: AppColors.royalBlue, bgElevated: bgElevated, borderCol: borderCol, textMuted: textMuted)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 3. Contingent Breakdown by Org Type
        GlassCard(
          padding: const EdgeInsets.all(16),
          borderColor: AppColors.royalBlue.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.royalBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.pie_chart_rounded, size: 18, color: AppColors.royalBlue),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'CONTINGENT DISTRIBUTION',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _progressRow('🎓 Educational & University Unions', 0.42, '42% (524 pax)', AppColors.royalBlue, bgElevated, textCol, textMuted),
              const SizedBox(height: 8),
              _progressRow('🏢 Corporate & Workplace Teams', 0.32, '32% (400 pax)', AppColors.vibrantEmerald, bgElevated, textCol, textMuted),
              const SizedBox(height: 8),
              _progressRow('🌱 NGOs & Civil Society Fronts', 0.26, '26% (324 pax)', AppColors.royalPurple, bgElevated, textCol, textMuted),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 4. Download Complete Log Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.royalPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
          ),
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text(
            'DOWNLOAD FULL DOMAIN AUDIT LOG',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, letterSpacing: 0.5),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.royalPurple,
                behavior: SnackBarBehavior.floating,
                content: Text('✓ Full Nagpur rally audit log (Incident Timestamps + Checkpoint Logs) exported.'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _metricTile(String val, String label, {required Color accent, required Color bgElevated, required Color borderCol, required Color textMuted}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderCol),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            val,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: accent, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _progressRow(String label, double ratio, String countText, Color color, Color bgElevated, Color textCol, Color textMuted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textCol), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 6),
            Text(countText, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 7,
            backgroundColor: bgElevated,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
