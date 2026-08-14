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
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.sosRed.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.emergency_share_rounded, color: AppColors.sosRed, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SOS EMERGENCY TRIAGE QUEUE (${unresolvedSos.length})',
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(radius: 3, backgroundColor: AppColors.sosRed),
                      SizedBox(width: 4),
                      Text('PRIORITY HIGH', style: TextStyle(fontSize: 9, color: AppColors.sosRed, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (unresolvedSos.isEmpty)
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
                          Text('All Clear • Zero Active SOS Alerts', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Domain telemetry & participant safety status is 100% nominal.', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              ...unresolvedSos.map((sos) {
                final isForwarded = sos.status == SosStatus.forwardedToAdmin;
                return GlassCard(
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isForwarded ? AppColors.warningAmber : AppColors.policeBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isForwarded ? '↗️ FORWARDED BY LEADER' : '🚨 DIRECT GENERAL SOS',
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 0.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(sos.senderName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.sosRed.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.sosRed.withOpacity(0.5)),
                            ),
                            child: Text(sos.emergencyType.name.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.sosRed)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('📞 ${sos.senderPhone}  •  Sub-Group: ${sos.activeSubGroupName ?? "General Group"}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      if (sos.leaderNotes != null)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amberAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amberAccent.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.notes_rounded, size: 14, color: Colors.amberAccent),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text('Leader Escalation Note: "${sos.leaderNotes}"', style: const TextStyle(fontSize: 11, color: Colors.amberAccent, fontStyle: FontStyle.italic)),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.sosRed,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: AppColors.sosRed.withOpacity(0.5),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.airport_shuttle_rounded, size: 16),
                              label: const Text('🚑 Dispatch Emergency Unit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => SosDispatchModal(sosEvent: sos),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.domainMarathon,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.check_circle_rounded, size: 16),
                            label: const Text('Resolve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              service.resolveSos(sos.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: AppColors.domainMarathon,
                                  content: Text('✓ Emergency incident resolved & logged.'),
                                ),
                              );
                            },
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
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.domainCycling.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.group_add_rounded, color: AppColors.domainCycling, size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  'PENDING GROUP APPLICATIONS (${pendingRequests.length})',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (pendingRequests.isEmpty)
              const GlassCard(
                child: Row(
                  children: [
                    Icon(Icons.inbox_rounded, color: AppColors.textMuted, size: 20),
                    SizedBox(width: 10),
                    Text('No pending group applications to review.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              )
            else
              ...pendingRequests.map((req) => GlassCard(
                    borderColor: AppColors.domainCycling.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(req.orgName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.domainCycling.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.domainCycling.withOpacity(0.4)),
                              ),
                              child: Text(req.orgCategory.name.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.domainCycling)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('👤 Applicant: ${req.applicantName} (${req.applicantPhone})  •  ~${req.expectedCount} Members', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        Text('📍 Muster Point: ${req.musterPoint}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E293B),
                                foregroundColor: AppColors.domainCycling,
                                side: BorderSide(color: AppColors.domainCycling.withOpacity(0.5)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.rate_review_rounded, size: 14),
                              label: const Text('Review Application >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => GroupApprovalDialog(request: req),
                                );
                              },
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
              boxShadow: [
                BoxShadow(
                  color: AppColors.policeBlue.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.cell_tower_rounded, color: AppColors.policeBlue, size: 22),
                      SizedBox(width: 10),
                      Text('DOMAIN-WIDE BROADCAST COMPOSER', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Send high-priority pop-up advisories, traffic diversions, or emergency notices to all registered participants.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.policeBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      shadowColor: AppColors.policeBlue.withOpacity(0.5),
                    ),
                    icon: const Icon(Icons.campaign_rounded, size: 18),
                    label: const Text('📢 OPEN BROADCAST COMPOSER', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5)),
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
