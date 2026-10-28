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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final currentDomain = service.currentDomain;
        final adminList = service.domainSuperAdmins[currentDomain.id] ?? [];

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            // Domain Selector
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.domain_rounded, size: 20, color: AppColors.royalPurple),
                  const SizedBox(width: 10),
                  Text('ACTIVE DOMAIN:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textCol)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<EventDomain>(
                        value: currentDomain,
                        dropdownColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                        isExpanded: true,
                        items: service.domains
                            .map((d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(d.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textCol)),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.security_rounded, size: 16, color: AppColors.royalPurple),
                          const SizedBox(width: 8),
                          Text(
                            'PROVISIONED SUPERADMINS (${adminList.length}/6 Allocated)',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.royalPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Soft Cap: 6', style: TextStyle(fontSize: 10, color: AppColors.royalPurple, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Direct developer seeding of trusted civic gatekeepers per isolated domain.',
                    style: TextStyle(fontSize: 11, color: textMuted),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _adminInputController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: textCol, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Enter gatekeeper phone (+91 98XXXXXXXX)',
                            hintStyle: TextStyle(color: textMuted, fontSize: 11.5),
                            filled: true,
                            fillColor: bgElevated,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderCol)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.royalPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final phone = _adminInputController.text.trim();
                          if (phone.isNotEmpty) {
                            service.provisionSuperAdmin(currentDomain.id, phone);
                            _adminInputController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.royalPurple,
                                content: Text('✓ Gatekeeper $phone provisioned for ${currentDomain.name}'),
                              ),
                            );
                          }
                        },
                        child: const Text('+ Add', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Simulation & Test Data Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.science_rounded, size: 16, color: AppColors.solarOrange),
                      const SizedBox(width: 8),
                      Text(
                        'TEMPORAL SIMULATION & DEMO SEEDING',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Force Live Event Window (Bypass start/end timer)',
                          style: TextStyle(fontSize: 12, color: textCol, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Switch(
                        value: service.forceLiveWindow,
                        activeTrackColor: AppColors.solarOrange,
                        onChanged: (val) {
                          service.toggleForceLiveWindow(val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.royalPurple,
                      side: BorderSide(color: AppColors.royalPurple.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                    label: const Text('+ Provision New Nagpur Domain', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CreateDomainModal(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
