import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';

class CreateDomainModal extends StatefulWidget {
  const CreateDomainModal({super.key});

  @override
  State<CreateDomainModal> createState() => _CreateDomainModalState();
}

class _CreateDomainModalState extends State<CreateDomainModal> {
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _summaryController = TextEditingController();
  DomainType _selectedType = DomainType.cycling;

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return Dialog(
      backgroundColor: AppColors.bgPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.domainParade),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.add_circle_outline_rounded, color: AppColors.domainParade, size: 24),
                SizedBox(width: 10),
                Text(
                  'PROVISION NEW EVENT DOMAIN',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Creates a 100% isolated event tenant with separate database tables, roles, and routes.',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Event Name (e.g. Orange City Walkathon 2026)',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                filled: true,
                fillColor: AppColors.surfaceCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _slugController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Slug Key (e.g. walkathon-2026)',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                filled: true,
                fillColor: AppColors.surfaceCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<DomainType>(
                  value: _selectedType,
                  dropdownColor: AppColors.surfaceCard,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: DomainType.cycling, child: Text('🚲 Cycling Rally Domain', style: TextStyle(color: Colors.white, fontSize: 12))),
                    DropdownMenuItem(value: DomainType.marathon, child: Text('🏃 City Marathon Domain', style: TextStyle(color: Colors.white, fontSize: 12))),
                    DropdownMenuItem(value: DomainType.protest, child: Text('📢 Citizen Protest Rally Domain', style: TextStyle(color: Colors.white, fontSize: 12))),
                    DropdownMenuItem(value: DomainType.walkathon, child: Text('🚶 Walkathon / Peace March', style: TextStyle(color: Colors.white, fontSize: 12))),
                    DropdownMenuItem(value: DomainType.parade, child: Text('🎪 Civic Parade / Procession', style: TextStyle(color: Colors.white, fontSize: 12))),
                  ],
                  onChanged: (t) {
                    if (t != null) setState(() => _selectedType = t);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _summaryController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Route Summary (e.g. 15 km Circuit)',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                filled: true,
                fillColor: AppColors.surfaceCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.domainParade,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (_nameController.text.trim().isNotEmpty && _slugController.text.trim().isNotEmpty) {
                  final now = DateTime.now();
                  final newDomain = EventDomain(
                    id: 'domain-${_slugController.text.trim()}',
                    name: _nameController.text.trim(),
                    slug: _slugController.text.trim(),
                    type: _selectedType,
                    status: DomainStatus.upcoming,
                    startTime: now.add(const Duration(days: 7)),
                    endTime: now.add(const Duration(days: 7, hours: 4)),
                    routeSummary: _summaryController.text.trim().isNotEmpty ? _summaryController.text.trim() : 'Official Circuit',
                  );
                  service.domains.add(newDomain);
                  service.switchDomain(newDomain);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✓ Isolated Event Domain ${newDomain.name} provisioned!')),
                  );
                }
              },
              child: const Text('PROVISION DOMAIN TENANT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
