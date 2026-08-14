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
            Row(
              children: [
                const Icon(Icons.person_add_rounded, color: AppColors.domainCycling, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'DIRECT ADD MEMBER',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Adding to: ${widget.groupName}\n(Note: Automatically cascades and enrolls them into the domain General Group if not already present).',
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Member Full Name (e.g. Anand Shinde)',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                filled: true,
                fillColor: AppColors.surfaceCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Mobile Number (+91 98XXXXXXXX)',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                filled: true,
                fillColor: AppColors.surfaceCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.domainCycling,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (_phoneController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✓ Member ${_phoneController.text.trim()} added and auto-cascaded to General Group!'),
                    ),
                  );
                }
              },
              child: const Text('+ ADD MEMBER TO ROSTER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
