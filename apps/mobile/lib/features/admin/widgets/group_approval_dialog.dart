import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';

class GroupApprovalDialog extends StatelessWidget {
  final GroupCreationRequest request;
  const GroupApprovalDialog({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: AppColors.royalPurple.withValues(alpha: 0.4), width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.royalPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.rate_review_rounded, color: AppColors.royalPurple, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'CONTINGENT REVIEW & APPOINTMENT',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderCol),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contingent: ${request.orgName}', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: textCol)),
                    const SizedBox(height: 3),
                    Text('Category: ${request.orgCategory.name.toUpperCase()}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.royalPurple)),
                    const SizedBox(height: 2),
                    Text('Proposed Leader: ${request.applicantName} (${request.applicantPhone})', style: TextStyle(fontSize: 11.5, color: textMuted)),
                    Text('Est. Strength: ~${request.expectedCount} Participants', style: TextStyle(fontSize: 11.5, color: textMuted)),
                    Text('Muster Point: ${request.musterPoint}', style: TextStyle(fontSize: 11.5, color: textMuted)),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bgElevated,
                        foregroundColor: AppColors.sosRed,
                        side: BorderSide(color: borderCol),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        service.rejectGroupRequest(request.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contingent application rejected.')),
                        );
                      },
                      child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.vibrantEmerald,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      onPressed: () {
                        service.approveGroupRequest(request.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.vibrantEmerald,
                            content: Text('✓ Approved ${request.orgName}! ${request.applicantName} appointed Leader.'),
                          ),
                        );
                      },
                      child: const Text('✓ Approve & Appoint', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
