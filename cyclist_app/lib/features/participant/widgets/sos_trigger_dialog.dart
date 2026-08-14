import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';

class SosTriggerDialog extends StatefulWidget {
  const SosTriggerDialog({super.key});

  @override
  State<SosTriggerDialog> createState() => _SosTriggerDialogState();
}

class _SosTriggerDialogState extends State<SosTriggerDialog> {
  SosEmergencyType _selectedType = SosEmergencyType.medical;
  final _noteController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final activeGroup = service.activeSubGroup;

    return Dialog(
      backgroundColor: AppColors.bgPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.sosRed, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.sosRedGlass,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: AppColors.sosRed, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMERGENCY SOS ALERT',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.sosRed),
                      ),
                      Text(
                        'Live GPS coordinates will be sent instantly',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Context-Aware Routing Note
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(Icons.route, size: 16, color: AppColors.domainCycling),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activeGroup != null
                          ? 'Routing directly to Group Leader: ${activeGroup.leaderName} (${activeGroup.name})'
                          : 'No active sub-group. Routing directly to SuperAdmin Triage Command.',
                      style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text('Select Emergency Type:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 8),

            // Emergency Type Selector
            Row(
              children: [
                _emergencyTypeChip(SosEmergencyType.medical, '🚑 Medical', AppColors.sosRed),
                const SizedBox(width: 8),
                _emergencyTypeChip(SosEmergencyType.breakdown, '🛠️ Breakdown', AppColors.warningAmber),
                const SizedBox(width: 8),
                _emergencyTypeChip(SosEmergencyType.threat, '⚠️ Threat', AppColors.policeBlue),
              ],
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _noteController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Brief note (e.g. Heatstroke at Km 5, crash, flat tyre)',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                filled: true,
                fillColor: AppColors.surfaceCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sosRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isSubmitting
                  ? null
                  : () {
                      setState(() => _isSubmitting = true);
                      service.triggerSos(
                        type: _selectedType,
                        lat: 21.1458,
                        lng: 79.0882,
                        note: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.sosRed,
                          content: Text(
                            activeGroup != null
                                ? '🚨 SOS Alert broadcasted to Leader: ${activeGroup.leaderName}!'
                                : '🚨 SOS Alert broadcasted to SuperAdmin Command!',
                          ),
                        ),
                      );
                    },
              child: const Text('🚨 BROADCAST SOS NOW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5)),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emergencyTypeChip(SosEmergencyType type, String label, Color accent) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? accent.withOpacity(0.2) : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? accent : AppColors.borderSubtle,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? accent : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
