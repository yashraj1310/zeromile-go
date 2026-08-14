import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';

class SosTriggerDialog extends StatefulWidget {
  final String? activeSubGroupName;
  final bool isGroupLeaderAssigned;

  const SosTriggerDialog({
    super.key,
    this.activeSubGroupName,
    this.isGroupLeaderAssigned = true,
  });

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
      backgroundColor: AppColors.bgPrimaryDark,
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
                    color: Color(0x33FF1744),
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
                        'Real-time GPS Location Included',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dynamic Context Routing Banner
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: activeGroup != null ? AppColors.domainCycling.withOpacity(0.1) : AppColors.sosRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: activeGroup != null ? AppColors.domainCycling.withOpacity(0.3) : AppColors.sosRed.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    activeGroup != null ? Icons.military_tech_rounded : Icons.admin_panel_settings_rounded,
                    size: 16,
                    color: activeGroup != null ? AppColors.domainCycling : AppColors.sosRed,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activeGroup != null
                          ? 'Routing to Group Leader: ${activeGroup.leaderName} (${activeGroup.name})'
                          : 'General Member: Routing directly to Domain SuperAdmin Command',
                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Select Emergency Nature:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: [
                _typeChip(SosEmergencyType.medical, '🚑 Medical Help', Colors.redAccent),
                _typeChip(SosEmergencyType.breakdown, '🛠️ Breakdown', Colors.amberAccent),
                _typeChip(SosEmergencyType.threat, '⚠️ Threat / Safety', Colors.orangeAccent),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _noteController,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Brief description (e.g., severe cramps at Km 4, need water/medic)',
                hintStyle: const TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                filled: true,
                fillColor: AppColors.surfaceCardDark,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sosRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: _isSubmitting
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send_rounded, size: 16),
                    label: Text(
                      _isSubmitting ? 'TRANSMITTING...' : 'TRANSMIT SOS',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            setState(() => _isSubmitting = true);
                            await Future.delayed(const Duration(milliseconds: 600));
                            service.triggerSos(
                              type: _selectedType,
                              lat: 21.1458,
                              lng: 79.0882,
                              note: _noteController.text.trim(),
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.sosRed,
                                  content: Text(
                                    activeGroup != null
                                        ? '🚨 SOS Transmitted to Leader ${activeGroup.leaderName}!'
                                        : '🚨 SOS Transmitted to SuperAdmin Command Queue!',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(SosEmergencyType type, String label, Color accent) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
      selected: isSelected,
      selectedColor: accent,
      backgroundColor: AppColors.surfaceCardDark,
      side: BorderSide(color: isSelected ? accent : AppColors.borderSubtleDark),
      onSelected: (val) {
        if (val) setState(() => _selectedType = type);
      },
    );
  }
}
