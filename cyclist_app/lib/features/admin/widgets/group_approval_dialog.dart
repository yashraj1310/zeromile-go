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

    return Dialog(
      backgroundColor: AppColors.bgPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.rate_review_rounded, color: AppColors.domainCycling, size: 22),
                SizedBox(width: 10),
                Text(
                  'GROUP APPLICATION REVIEW',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text('Org Name: ${request.orgName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Category: ${request.orgCategory.name.toUpperCase()}', style: const TextStyle(fontSize: 11, color: AppColors.domainCycling)),
            Text('Applicant / Proposed Leader: ${request.applicantName} (${request.applicantPhone})', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text('Contingent Size: ~${request.expectedCount} Participants', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text('Muster Point: ${request.musterPoint}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            if (request.leaderNotes != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('Remarks: "${request.leaderNotes}"', style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontStyle: FontStyle.italic)),
              ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sosRed.withOpacity(0.2),
                      foregroundColor: AppColors.sosRed,
                      side: const BorderSide(color: AppColors.sosRed),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      service.rejectGroupRequest(request.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Application rejected.')),
                      );
                    },
                    child: const Text('✗ REJECT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.domainMarathon,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      service.approveGroupRequest(request.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.domainMarathon,
                          content: Text('✓ Approved ${request.orgName}! ${request.applicantName} appointed Group Leader.'),
                        ),
                      );
                    },
                    child: const Text('✓ APPROVE & APPOINT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
