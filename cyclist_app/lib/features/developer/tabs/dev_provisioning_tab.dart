import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/create_domain_modal.dart';

class DevProvisioningTab extends StatefulWidget {
  const DevProvisioningTab({super.key});

  @override
  State<DevProvisioningTab> createState() => _DevProvisioningTabState();
}

class _DevProvisioningTabState extends State<DevProvisioningTab> {
  final _adminInputController = TextEditingController();

  @override
  void dispose() {
    _adminInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final currentDomain = service.currentDomain;
        final adminList = service.domainSuperAdmins[currentDomain.id] ?? [];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Domain Selector
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.domain_rounded, size: 20, color: AppColors.domainParade),
                  const SizedBox(width: 10),
                  const Text('SELECT DOMAIN:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<EventDomain>(
                        value: currentDomain,
                        dropdownColor: AppColors.surfaceCard,
                        isExpanded: true,
                        items: service.domains
                            .map((d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(d.name, style: const TextStyle(fontSize: 12, color: Colors.white)),
                                ))
                            .toList(),
                        onChanged: (d) {
                          if (d != null) service.switchDomain(d);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Provisioned SuperAdmins Card
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.security_rounded, size: 16, color: AppColors.domainParade),
                          const SizedBox(width: 8),
                          Text(
                            'PROVISIONED SUPERADMINS (${adminList.length}/6 Allocated)',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.domainParade.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Soft Cap: 6', style: TextStyle(fontSize: 10, color: AppColors.domainParade, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Direct developer seeding of trusted civic gatekeepers per isolated domain.',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),

                  ...adminList.asMap().entries.map((entry) => Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHover,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${entry.key + 1}. ${entry.value}',
                              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                            const Text('Active Gatekeeper', style: TextStyle(fontSize: 10, color: AppColors.domainMarathon)),
                          ],
                        ),
                      )),

                  const SizedBox(height: 10),

                  if (adminList.length < 6)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _adminInputController,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Name (+91 98XXXXXXXX)',
                              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                              filled: true,
                              fillColor: const Color(0xFF0F172A),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.domainParade,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          onPressed: () {
                            if (_adminInputController.text.trim().isNotEmpty) {
                              service.addSuperAdmin(currentDomain.id, _adminInputController.text.trim());
                              _adminInputController.clear();
                            }
                          },
                          child: const Text('+ Add Admin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Domain Actions Toolbar
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceCard,
                      foregroundColor: AppColors.domainParade,
                      side: const BorderSide(color: AppColors.domainParade),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: const Text('+ New Domain', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CreateDomainModal(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceCard,
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.borderSubtle),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.restart_alt_rounded, size: 18),
                    label: const Text('Reset DB Cache', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✓ Redis geo-cache and WebSocket pipelines flushed successfully.')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
