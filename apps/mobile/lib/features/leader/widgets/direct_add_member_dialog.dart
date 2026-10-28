import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DirectAddMemberDialog extends StatefulWidget {
  final String groupName;
  const DirectAddMemberDialog({super.key, required this.groupName});

  @override
  State<DirectAddMemberDialog> createState() => _DirectAddMemberDialogState();
}

class _DirectAddMemberDialogState extends State<DirectAddMemberDialog> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        side: BorderSide(color: AppColors.solarOrange.withValues(alpha: 0.4), width: 1.5),
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
                      color: AppColors.solarOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person_add_rounded, color: AppColors.solarOrange, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DIRECT ADD TEAM MEMBER',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                        ),
                        Text(
                          'Instant phone enrollment tool',
                          style: TextStyle(fontSize: 10.5, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderCol),
                ),
                child: Text(
                  '📍 Contingent: ${widget.groupName}\nℹ️ Auto-cascades and enrolls them into the event General Group if not present.',
                  style: TextStyle(fontSize: 11, color: textMuted, height: 1.3),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _nameController,
                style: TextStyle(color: textCol, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Member Full Name (e.g. Anand Shinde)',
                  hintStyle: TextStyle(color: textMuted, fontSize: 11.5),
                  filled: true,
                  fillColor: bgElevated,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderCol)),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: textCol, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Mobile Number (+91 98XXXXXXXX)',
                  hintStyle: TextStyle(color: textMuted, fontSize: 11.5),
                  filled: true,
                  fillColor: bgElevated,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderCol)),
                ),
              ),
              const SizedBox(height: 18),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.solarOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.check_rounded, size: 16),
                label: const Text('ENROLL MEMBER TO TEAM', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                onPressed: () {
                  if (_phoneController.text.trim().isNotEmpty && _nameController.text.trim().isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.vibrantEmerald,
                        behavior: SnackBarBehavior.floating,
                        content: Text('✓ Enrolled ${_nameController.text} into ${widget.groupName}!'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
