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
  final _descController = TextEditingController();
  bool _isTriggering = false;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final activeGroup = service.activeSubGroup;
    final isDark = service.themeMode == ThemeMode.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.sosRed, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.sosRed.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emergency_rounded, color: AppColors.sosRed, size: 24),
                ),
                const SizedBox(width: 10),
                Text(
                  'TRIGGER EMERGENCY SOS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Dynamic Context Routing Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    activeGroup != null ? Icons.groups_rounded : Icons.shield_outlined,
                    size: 20,
                    color: activeGroup != null ? AppColors.domainCycling : AppColors.sosRed,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeGroup != null
                              ? 'ROUTING: Leader ${activeGroup.leaderName}'
                              : 'ROUTING: Domain SuperAdmin Queue',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: activeGroup != null
                                ? (isDark ? AppColors.domainCycling : const Color(0xFF0284C7))
                                : AppColors.sosRed,
                          ),
                        ),
                        Text(
                          activeGroup != null
                              ? 'Group: ${activeGroup.name} (${activeGroup.leaderPhone})'
                              : 'You are riding independently. Direct SuperAdmin dispatch.',
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Emergency Type Selector
            Text(
              'Select Emergency Category:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _typeChip(SosEmergencyType.medical, '🚑 Medical', AppColors.sosRed),
                const SizedBox(width: 6),
                _typeChip(SosEmergencyType.breakdown, '🛠️ Breakdown', AppColors.domainProtest),
                const SizedBox(width: 6),
                _typeChip(SosEmergencyType.threat, '⚠️ Threat', AppColors.domainMarathon),
              ],
            ),
            const SizedBox(height: 16),

            // Description Input
            TextField(
              controller: _descController,
              maxLines: 2,
              style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Brief details (e.g. Fallen at Shankar Nagar sq, bleeding knee)',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sosRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _isTriggering
                        ? null
                        : () {
                            setState(() => _isTriggering = true);
                            service.triggerSos(
                              type: _selectedType,
                              lat: 21.1350,
                              lng: 79.0700,
                              note: _descController.text.trim(),
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.sosRed,
                                content: Text(
                                  activeGroup != null
                                      ? '🚨 SOS Dispatched to Leader ${activeGroup.leaderName}!'
                                      : '🚨 SOS Dispatched directly to SuperAdmin Emergency Queue!',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            );
                          },
                    child: const Text('🚨 SEND SOS NOW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(SosEmergencyType type, String label, Color color) {
    final isSelected = _selectedType == type;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : AppColors.textMuted.withValues(alpha: 0.3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
              color: isSelected ? color : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
