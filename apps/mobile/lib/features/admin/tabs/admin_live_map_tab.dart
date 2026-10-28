import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/dynamic_density_map_view.dart';
import '../../../core/widgets/glass_card.dart';

class AdminLiveMapTab extends StatefulWidget {
  const AdminLiveMapTab({super.key});

  @override
  State<AdminLiveMapTab> createState() => _AdminLiveMapTabState();
}

class _AdminLiveMapTabState extends State<AdminLiveMapTab> {
  String _selectedFilter = 'all';

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
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            // Sub-Group Filter Dropdown
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt_rounded, size: 18, color: AppColors.royalPurple),
                  const SizedBox(width: 10),
                  Text('FILTER CONTINGENTS:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textCol)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        dropdownColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('🌐 All Field (1,248 Pax)', style: TextStyle(fontSize: 12, color: textCol, fontWeight: FontWeight.w700))),
                          DropdownMenuItem(value: 'vnit', child: Text('🎓 VNIT Cycling Club (38)', style: TextStyle(fontSize: 12, color: textCol, fontWeight: FontWeight.w700))),
                          DropdownMenuItem(value: 'orange', child: Text('⚡ Orange City Sprinters (28)', style: TextStyle(fontSize: 12, color: textCol, fontWeight: FontWeight.w700))),
                          DropdownMenuItem(value: 'msedcl', child: Text('🏢 MSEDCL Riders (45)', style: TextStyle(fontSize: 12, color: textCol, fontWeight: FontWeight.w700))),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedFilter = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Domain-Wide Live Density Map View
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderCol),
              ),
              clipBehavior: Clip.antiAlias,
              child: const DynamicDensityMapView(
                title: 'Nagpur Civic Rally Density Map',
                height: 300,
                showSosPins: true,
                isLeaderScope: false,
              ),
            ),
            const SizedBox(height: 14),

            // Live Crowd & Escort Telemetry
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.hub_rounded, size: 16, color: AppColors.royalPurple),
                      const SizedBox(width: 8),
                      Text(
                        'SECTOR CONCENTRATION SUMMARY',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _densityRow('🔴 Shankar Nagar Square', '450 Pax (Peak Density - Marshals On-Site)', AppColors.sosRed, textMuted),
                  _densityRow('🔵 Law College Square', '180 Pax (Moderate Flow)', AppColors.royalBlue, textMuted),
                  _densityRow('🟢 Zero Mile Heritage Start', '65 Pax (Clearing / Tail Guard)', AppColors.vibrantEmerald, textMuted),
                  const SizedBox(height: 12),
                  Divider(color: borderCol, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgElevated,
                            foregroundColor: AppColors.sosRed,
                            side: BorderSide(color: borderCol),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.airport_shuttle_rounded, size: 16),
                          label: const Text('Track Aid Vans (2)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: AppColors.sosRed,
                                behavior: SnackBarBehavior.floating,
                                content: Text('🚑 Aid Van #1 at Law College Sq, Aid Van #2 at Ambazari Gate.'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgElevated,
                            foregroundColor: AppColors.royalBlue,
                            side: BorderSide(color: borderCol),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.water_drop_rounded, size: 16),
                          label: const Text('Hydration Posts (4)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: AppColors.royalBlue,
                                behavior: SnackBarBehavior.floating,
                                content: Text('💧 All 4 Hydration posts reporting stocked supplies.'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _densityRow(String title, String subtitle, Color color, Color textMuted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
          Text(subtitle, style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
