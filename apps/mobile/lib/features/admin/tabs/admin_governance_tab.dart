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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final unresolvedSos = service.sosEvents.where((s) => s.status != SosStatus.resolved).toList();
        final pendingRequests = service.groupRequests.where((r) => r.status == 'PENDING').toList();

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            // 1. SOS Emergency Triage Queue
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
                      child: const Icon(Icons.emergency_share_rounded, color: AppColors.sosRed, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SOS EMERGENCY TRIAGE QUEUE (${unresolvedSos.length})',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.sosRed, letterSpacing: 0.5),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.sosRedGlass,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.sosRed.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(radius: 3, backgroundColor: AppColors.sosRed),
                      SizedBox(width: 4),
                      Text('PRIORITY HIGH', style: TextStyle(fontSize: 9, color: AppColors.sosRed, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (unresolvedSos.isEmpty)
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
                          Text('All Clear • Zero Active SOS Alerts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textCol)),
                          Text('Participant safety status across all circuits is nominal.', style: TextStyle(fontSize: 11, color: textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              ...unresolvedSos.map((sos) {
                final isForwarded = sos.status == SosStatus.forwardedToAdmin;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    borderColor: AppColors.sosRed,
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
                                    color: isForwarded ? AppColors.sunnyGold : AppColors.royalBlue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isForwarded ? 'LEADER ESCALATION' : 'DIRECT CITIZEN SOS',
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(sos.senderName, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: textCol)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.sosRed.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(sos.emergencyType.name.toUpperCase(), style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: AppColors.sosRed)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('📞 ${sos.senderPhone}  •  Contingent: ${sos.activeSubGroupName ?? "General Field"}', style: TextStyle(fontSize: 11.5, color: textMuted)),
                        if (sos.leaderNotes != null)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.sunnyGold.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.sunnyGold.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.notes_rounded, size: 14, color: AppColors.sunnyGold),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text('Leader Note: "${sos.leaderNotes}"', style: const TextStyle(fontSize: 11, color: AppColors.sunnyGold, fontStyle: FontStyle.italic)),
                                ),
                              ],
                            ),
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                ),
                                icon: const Icon(Icons.local_hospital_rounded, size: 14),
                                label: const Text('Dispatch Aid Van', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => SosDispatchModal(sosEvent: sos),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
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
                                label: const Text('Resolve SOS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                onPressed: () => service.resolveSos(sos.id),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

            const SizedBox(height: 20),

            // 2. Pending Group Creation Approvals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.royalPurple.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.group_add_rounded, color: AppColors.royalPurple, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PENDING CONTINGENT APPROVALS (${pendingRequests.length})',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.royalPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('VETTING QUEUE', style: TextStyle(fontSize: 9, color: AppColors.royalPurple, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (pendingRequests.isEmpty)
              GlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.task_alt_rounded, color: AppColors.vibrantEmerald, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('All contingent applications have been reviewed.', style: TextStyle(fontSize: 11.5, color: textMuted)),
                    ),
                  ],
                ),
              )
            else
              ...pendingRequests.map((req) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: GlassCard(
                      borderColor: AppColors.royalPurple.withValues(alpha: 0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(req.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textCol)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.royalPurple.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(req.orgCategory.name.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.royalPurple)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Leader: ${req.applicantName} (${req.applicantPhone})  •  Est: ~${req.estimatedCount} pax', style: TextStyle(fontSize: 11.5, color: textMuted)),
                          Text('Muster Assembly Point: ${req.musterPoint}', style: TextStyle(fontSize: 11, color: textMuted)),
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
                                  icon: const Icon(Icons.check_rounded, size: 14),
                                  label: const Text('Approve Contingent', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => GroupApprovalDialog(request: req),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: bgElevated,
                                    foregroundColor: AppColors.sosRed,
                                    side: BorderSide(color: borderCol),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.close_rounded, size: 14),
                                  label: const Text('Reject', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  onPressed: () => service.rejectGroupRequest(req.id),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),

            const SizedBox(height: 20),

            // 3. Domain Broadcast Action Banner
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderColor: AppColors.royalPurple.withValues(alpha: 0.35),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.royalPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.campaign_rounded, color: AppColors.royalPurple, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CITY-WIDE CIVIC BROADCAST', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textCol)),
                        const SizedBox(height: 2),
                        Text('Send official alerts to all registered participants in Nagpur.', style: TextStyle(fontSize: 11, color: textMuted)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.royalPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const DomainBroadcastDialog(),
                      );
                    },
                    child: const Text('Broadcast', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
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
