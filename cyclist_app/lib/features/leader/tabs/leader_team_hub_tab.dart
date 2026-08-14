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

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final activeSosList = service.sosEvents
            .where((s) => s.activeSubGroupId == 'group-vnit-riders' && s.status != SosStatus.resolved)
            .toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Team SOS Alerts Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.sosRed.withOpacity(0.15),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.sosRedGlass,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.sosRed.withOpacity(0.5)),
                  ),
                  child: const Text('FIRST RESPONSE', style: TextStyle(fontSize: 9, color: AppColors.sosRed, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (activeSosList.isEmpty)
              GlassCard(
                backgroundColor: const Color(0x1A00E676),
                borderColor: AppColors.domainMarathon.withOpacity(0.4),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: AppColors.domainMarathon, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No Active Team Emergencies', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('All 38 contingent riders report normal safety status.', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              ...activeSosList.map((sos) => GlassCard(
                    borderColor: AppColors.sosRed,
                    backgroundColor: const Color(0x2E1E090D),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sosRed.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'FROM: ${sos.senderName}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.sosRed,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                sos.emergencyType.name.toUpperCase(),
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('📞 ${sos.senderPhone}  •  Status: First Response Pending', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        if (sos.leaderNotes != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('Notes: "${sos.leaderNotes}"', style: const TextStyle(fontSize: 11, color: Colors.amberAccent, fontStyle: FontStyle.italic)),
                          ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.policeBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.phone_rounded, size: 14),
                                label: const Text('Call', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Calling ${sos.senderPhone}...')),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.domainMarathon,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.check_circle_rounded, size: 14),
                                label: const Text('Resolve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                onPressed: () => service.resolveSos(sos.id),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.sosRed,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                                label: const Text('Forward', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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

            const SizedBox(height: 18),

            // 2. Direct Add Member & Team Broadcast Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: AppColors.domainCycling,
                      side: BorderSide(color: AppColors.domainCycling.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.person_add_rounded, size: 16),
                    label: const Text('+ Direct Add Member', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: AppColors.domainMarathon,
                      side: BorderSide(color: AppColors.domainMarathon.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.campaign_rounded, size: 16),
                    label: const Text('📣 Broadcast to Team', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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

            // 3. Team Member Roster Section
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TEAM ROSTER (38 Enrolled)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                Text('Assembly: Ambazari Gate', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),

            _rosterTile('Rajesh Sharma', 'Leader • Checked-in at Muster', Icons.star_rounded, AppColors.domainCycling),
            _rosterTile('Aniket Deshmukh', 'Active • En Route (Km 4.2)', Icons.directions_bike_rounded, AppColors.domainMarathon),
            _rosterTile('Priya Verma', 'Active • SOS Flagged (Heatstroke)', Icons.warning_amber_rounded, AppColors.sosRed),
            _rosterTile('Kavita Nair', 'Active • En Route (Km 3.8)', Icons.directions_bike_rounded, AppColors.domainMarathon),
            _rosterTile('Saurabh Joshi', 'Active • Checked-in at Muster', Icons.check_circle_outline, AppColors.textSecondary),
            _rosterTile('Rahul Mehra', 'Standstill / Lagging (Km 1.2)', Icons.access_time_rounded, AppColors.warningAmber),
          ],
        );
      },
    );
  }

  static Widget _rosterTile(String name, String status, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(status, style: TextStyle(fontSize: 11, color: color)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textMuted),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
