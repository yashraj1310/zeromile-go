import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class LeaderAnalyticsTab extends StatelessWidget {
  const LeaderAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // 1. Muster Roll & Attendance Card
        GlassCard(
          padding: const EdgeInsets.all(18),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.fact_check_rounded, size: 18, color: AppColors.royalPurple),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'MUSTER ROLL & ATTENDANCE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: textCol,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stat Grid (2x2)
              Row(
                children: [
                  Expanded(child: _statItem('38', 'Total Enrolled', textCol, bgElevated, borderCol, textMuted)),
                  const SizedBox(width: 8),
                  Expanded(child: _statItem('34', 'Active (89%)', AppColors.royalPurple, bgElevated, borderCol, textMuted)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _statItem('32', 'Checked-in (94%)', AppColors.vibrantEmerald, bgElevated, borderCol, textMuted)),
                  const SizedBox(width: 8),
                  Expanded(child: _statItem('18', 'Finished', AppColors.royalBlue, bgElevated, borderCol, textMuted)),
                ],
              ),
              const SizedBox(height: 18),

              Text(
                'Muster Assembly Progress (Ambazari Gate):',
                style: TextStyle(fontSize: 11.5, color: textMuted, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.941,
                  minHeight: 10,
                  backgroundColor: bgElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.vibrantEmerald),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '32 of 34 Active Checked-in (94.1%)',
                  style: const TextStyle(fontSize: 10.5, color: AppColors.vibrantEmerald, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Incident & Safety Log Card (No Telemetry)
        GlassCard(
          padding: const EdgeInsets.all(18),
          borderColor: AppColors.vibrantEmerald.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.vibrantEmerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.health_and_safety_rounded, size: 18, color: AppColors.vibrantEmerald),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'SAFETY & INCIDENT LOG',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: textCol,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _incidentRow('🚨 Triggered SOS Alert', '1 Event (Forwarded)', AppColors.sosRed, textCol, textMuted),
              const SizedBox(height: 8),
              _incidentRow('🚑 SuperAdmin Ambulance Dispatched', 'Resolved (ETA ~3m)', AppColors.vibrantEmerald, textCol, textMuted),
              const SizedBox(height: 8),
              _incidentRow('💧 Hydration Checkpoint Passed', 'All 34 accounted for', AppColors.royalBlue, textCol, textMuted),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 3. Export Attendance Roll Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.royalBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
          ),
          icon: const Icon(Icons.file_download_outlined, size: 18),
          label: const Text(
            'EXPORT MUSTER ATTENDANCE (CSV)',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, letterSpacing: 0.5),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.royalBlue,
                behavior: SnackBarBehavior.floating,
                content: Text('✓ VNIT muster check-in list (34 active riders) exported to CSV.'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _statItem(String val, String label, Color accent, Color bgElevated, Color borderCol, Color textMuted) {
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

  Widget _incidentRow(String title, String status, Color statusColor, Color textCol, Color textMuted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 11.5, color: textCol, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: statusColor),
        ),
      ],
    );
  }
}
