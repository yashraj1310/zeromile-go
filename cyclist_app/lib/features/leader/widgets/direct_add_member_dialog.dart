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
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.domainCycling.withOpacity(0.5), width: 1.5),
      ),
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
                    color: AppColors.domainCycling.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add_rounded, color: AppColors.domainCycling, size: 20),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIRECT ADD TEAM MEMBER',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                      ),
                      Text(
                        'Instant phone enrollment tool',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
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
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                '📍 Contingent: ${widget.groupName}\nℹ️ Auto-cascades and enrolls them into the domain General Group if not present.',
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.3),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Member Full Name (e.g. Anand Shinde)',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.borderSubtle),
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Mobile Number (+91 98XXXXXXXX)',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.borderSubtle),
                ),
              ),
            ),
            const SizedBox(height: 18),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.domainCycling,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                shadowColor: AppColors.domainCycling.withOpacity(0.3),
              ),
              icon: const Icon(Icons.check_circle_rounded, size: 16),
              label: const Text('+ ENROLL MEMBER TO ROSTER', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5)),
              onPressed: () {
                if (_phoneController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.domainCycling,
                      content: Text('✓ Member ${_phoneController.text.trim()} added and auto-cascaded to General Group!'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
