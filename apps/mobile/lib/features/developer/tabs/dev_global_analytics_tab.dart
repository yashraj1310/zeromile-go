import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class DevGlobalAnalyticsTab extends StatelessWidget {
  const DevGlobalAnalyticsTab({super.key});

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
        // 1. All Domains Overview
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
                    child: const Icon(Icons.public_rounded, size: 16, color: AppColors.royalPurple),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'GLOBAL NAGPUR DOMAIN OVERVIEW',
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
                  Expanded(child: _metric('4', 'Active Events', AppColors.royalPurple, bgElevated, borderCol, textCol, textMuted)),
                  const SizedBox(width: 8),
                  Expanded(child: _metric('5,498', 'Registered Users', textCol, bgElevated, borderCol, textCol, textMuted)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _metric('52', 'Contingents', AppColors.vibrantEmerald, bgElevated, borderCol, textCol, textMuted)),
                  const SizedBox(width: 8),
                  Expanded(child: _metric('16', 'Gatekeepers', AppColors.solarOrange, bgElevated, borderCol, textCol, textMuted)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Domain-by-Domain Breakdown
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
                    child: const Icon(Icons.layers_rounded, size: 16, color: AppColors.royalBlue),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'USERS BY EVENT DOMAIN',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _domainRow('🚲 Heritage Cycling Circuit', '1,248 Users (22.7%)', AppColors.solarOrange, textMuted),
              _domainRow('🏃 City Green Marathon', '3,400 Users (61.8%)', AppColors.vibrantEmerald, textMuted),
              _domainRow('📢 Citizen Peace & Civic Rally', '850 Users (15.5%)', AppColors.royalPurple, textMuted),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 3. Infrastructure & Pipeline Health
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.vibrantEmerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.dns_rounded, size: 16, color: AppColors.vibrantEmerald),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'INFRASTRUCTURE PIPELINE & LOAD',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _healthItem('🔌 WebSocket Gateway', '2,140 Streams', AppColors.vibrantEmerald, textMuted),
              _healthItem('⚡ Geolocation Latency', '48ms (Optimal)', AppColors.solarOrange, textMuted),
              _healthItem('🗄️ PostgreSQL Database Pool', '22% Utilized', AppColors.vibrantEmerald, textMuted),
              _healthItem('🧠 Redis In-Memory Geo Cache', '14.2 MB / 512 MB', AppColors.royalBlue, textMuted),
            ],
          ),
        ),

        const SizedBox(height: 18),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.royalPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          icon: const Icon(Icons.sync_rounded, size: 18),
          label: const Text('🔄 REFRESH GLOBAL METRICS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.royalPurple,
                content: Text('✓ Global telemetry and database metrics synced.'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _metric(String val, String label, Color accent, Color bgElevated, Color borderCol, Color textCol, Color textMuted) {
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
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: accent, fontFamily: 'monospace')),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _domainRow(String title, String subtitle, Color color, Color textMuted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: color), maxLines: 1, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          Text(subtitle, style: TextStyle(fontSize: 10.5, color: textMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _healthItem(String name, String status, Color color, Color textMuted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name, style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}
