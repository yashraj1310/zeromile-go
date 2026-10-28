import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/direct_add_member_dialog.dart';
import '../widgets/forward_sos_modal.dart';
import '../widgets/team_broadcast_dialog.dart';

class LeaderTeamHubTab extends StatelessWidget {
  const LeaderTeamHubTab({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final activeSosList = service.sosEvents
            .where((s) => s.activeSubGroupId == 'group-vnit-riders' && s.status != SosStatus.resolved)
            .toList();

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            // 1. Rich Contingent Banner Card
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1541625602330-2277a4c46182?auto=format&fit=crop&w=800&q=80'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'VNIT Cycling Club Contingent',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.place_rounded, color: AppColors.sunnyGold, size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  'Muster Point: Ambazari South Gate (06:00 AM)',
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.solarOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '38 RIDERS',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Team SOS Triage Queue Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.sosRed.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: AppColors.sosRed, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'TEAM SOS TRIAGE QUEUE (${activeSosList.length} Active)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.sosRed, letterSpacing: 0.5),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.sosRedGlass,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.sosRed.withValues(alpha: 0.4)),
                  ),
                  child: const Text('FIRST RESPONSE', style: TextStyle(fontSize: 9, color: AppColors.sosRed, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (activeSosList.isEmpty)
              GlassCard(
                borderColor: AppColors.vibrantEmerald.withValues(alpha: 0.35),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.vibrantEmerald.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: AppColors.vibrantEmerald, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No Active Contingent Emergencies', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textCol)),
                          Text('All 38 contingent riders report clear safety status.', style: TextStyle(fontSize: 11, color: textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              ...activeSosList.map((sos) => GlassCard(
                    borderColor: AppColors.sosRed,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'FROM: ${sos.senderName}',
                              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: textCol),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.sosRed.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                sos.emergencyType.name.toUpperCase(),
                                style: const TextStyle(color: AppColors.sosRed, fontSize: 10, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          sos.note ?? 'Emergency assistance requested on course.',
                          style: TextStyle(color: textMuted, fontSize: 11.5),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.vibrantEmerald,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                ),
                                icon: const Icon(Icons.check_circle_rounded, size: 14),
                                label: const Text('Resolve Locally', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                onPressed: () => service.resolveSos(sos.id),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.sosRed,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                ),
                                icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                                label: const Text('Escalate to Admin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ForwardSosModal(sosEvent: sos),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),

            const SizedBox(height: 16),

            // 3. Quick Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgElevated,
                      foregroundColor: textCol,
                      side: BorderSide(color: borderCol),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.person_add_rounded, size: 16, color: AppColors.solarOrange),
                    label: const Text('+ Add Member', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const DirectAddMemberDialog(groupName: 'VNIT Cycling Club'),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgElevated,
                      foregroundColor: textCol,
                      side: BorderSide(color: borderCol),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.campaign_rounded, size: 16, color: AppColors.vibrantEmerald),
                    label: const Text('📣 Broadcast', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const TeamBroadcastDialog(groupName: 'VNIT Cycling Club'),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // 4. Team Member Roster Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TEAM ROSTER (38 ENROLLED)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: textCol,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  'Muster: Ambazari South Gate',
                  style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _rosterTile(context, 'Contingent Leader', 'Leader • Checked-in at Muster', Icons.star_rounded, AppColors.solarOrange, 'CL'),
            _rosterTile(context, 'Aniket Deshmukh', 'Checked-in at Muster (06:05 AM)', Icons.check_circle_rounded, AppColors.vibrantEmerald, 'AD'),
            _rosterTile(context, 'Priya Verma', 'SOS Flagged (Local First-Aid)', Icons.warning_amber_rounded, AppColors.sosRed, 'PV'),
            _rosterTile(context, 'Kavita Nair', 'En Route to Muster Point', Icons.directions_bike_rounded, AppColors.solarOrange, 'KN'),
            _rosterTile(context, 'Saurabh Joshi', 'Checked-in at Muster (06:12 AM)', Icons.check_circle_rounded, AppColors.vibrantEmerald, 'SJ'),
            _rosterTile(context, 'Rahul Mehra', 'Standstill / At Assembly Tent', Icons.access_time_rounded, AppColors.sunnyGold, 'RM'),
          ],
        );
      },
    );
  }

  Widget _rosterTile(BuildContext context, String name, String status, IconData icon, Color statusColor, String initials) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: statusColor.withValues(alpha: 0.15),
              child: Text(
                initials,
                style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: textCol)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(icon, color: statusColor, size: 13),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          status,
                          style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.phone_outlined, size: 18, color: textMuted),
              tooltip: 'Call Member',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.solarOrange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    content: Text('📞 Calling $name...'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
