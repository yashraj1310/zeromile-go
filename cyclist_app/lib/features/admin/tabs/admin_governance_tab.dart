import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/domain_broadcast_dialog.dart';
import '../widgets/group_approval_dialog.dart';
import '../widgets/sos_dispatch_modal.dart';

class AdminGovernanceTab extends StatelessWidget {
  const AdminGovernanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final unresolvedSos = service.sosEvents.where((s) => s.status != SosStatus.resolved).toList();
        final pendingRequests = service.groupRequests.where((r) => r.status == 'PENDING').toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. ESCALATED & DIRECT SOS QUEUE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emergency_share_rounded, color: AppColors.sosRed, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'SOS EMERGENCY TRIAGE QUEUE (${unresolvedSos.length})',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.sosRed, letterSpacing: 0.5),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.sosRedGlass,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Priority High', style: TextStyle(fontSize: 9, color: AppColors.sosRed, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (unresolvedSos.isEmpty)
              const GlassCard(
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: AppColors.domainMarathon, size: 20),
                    SizedBox(width: 10),
                    Text('Zero active SOS emergencies in domain.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              )
            else
              ...unresolvedSos.map((sos) {
                final isForwarded = sos.status == SosStatus.forwardedToAdmin;
                return GlassCard(
                  borderColor: AppColors.sosRed,
                  backgroundColor: const Color(0x33FF1744),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isForwarded ? AppColors.warningAmber : AppColors.policeBlue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isForwarded ? '↗️ FORWARDED BY LEADER' : '🚨 DIRECT GENERAL SOS',
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(sos.senderName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                          Text(sos.emergencyType.name.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.sosRed)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Phone: ${sos.senderPhone} • Sub-Group: ${sos.activeSubGroupName ?? "General Group"}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      if (sos.leaderNotes != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('Leader Escalation Note: "${sos.leaderNotes}"', style: const TextStyle(fontSize: 11, color: Colors.amberAccent, fontStyle: FontStyle.italic)),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.sosRed,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              icon: const Icon(Icons.airport_shuttle_rounded, size: 16),
                              label: const Text('🚑 Dispatch Unit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => SosDispatchModal(sosEvent: sos),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.domainMarathon,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                            onPressed: () => service.resolveSos(sos.id),
                            child: const Text('✓ Resolve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 20),

            // 2. PENDING GROUP APPLICATIONS
            Row(
              children: [
                const Icon(Icons.group_add_rounded, color: AppColors.domainCycling, size: 18),
                const SizedBox(width: 8),
                Text(
                  'PENDING GROUP APPLICATIONS (${pendingRequests.length})',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (pendingRequests.isEmpty)
              const GlassCard(
                child: Text('No pending group applications to review.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              )
            else
              ...pendingRequests.map((req) => GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(req.orgName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.domainCycling.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(req.orgCategory.name.toUpperCase(), style: const TextStyle(fontSize: 9, color: AppColors.domainCycling)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Applicant: ${req.applicantName} (${req.applicantPhone}) • ~${req.expectedCount} Members', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        Text('Muster Point: ${req.musterPoint}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.surfaceHover,
                                foregroundColor: AppColors.domainCycling,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => GroupApprovalDialog(request: req),
                                );
                              },
                              child: const Text('Review Application >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),

            const SizedBox(height: 24),

            // 3. BROADCAST PUBLISHER CTA
            GlassCard(
              backgroundColor: const Color(0x2E2979FF),
              borderColor: AppColors.policeBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.cell_tower_rounded, color: AppColors.policeBlue, size: 20),
                      SizedBox(width: 10),
                      Text('DOMAIN-WIDE BROADCAST COMPOSER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Send high-priority pop-up advisories, traffic diversions, or emergency notices to all participants.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.policeBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.campaign_rounded, size: 16),
                    label: const Text('📢 OPEN BROADCAST COMPOSER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const DomainBroadcastDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
