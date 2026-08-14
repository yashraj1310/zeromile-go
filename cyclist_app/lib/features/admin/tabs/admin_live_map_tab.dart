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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Sub-Group Filter Dropdown
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.filter_alt_rounded, size: 18, color: AppColors.domainCycling),
              const SizedBox(width: 10),
              const Text('FILTER PARTICIPANTS:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    dropdownColor: AppColors.surfaceCard,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('🌐 All General (1,248 Pax)', style: TextStyle(fontSize: 12, color: Colors.white))),
                      DropdownMenuItem(value: 'vnit', child: Text('🎓 VNIT Cycling Club (38)', style: TextStyle(fontSize: 12, color: Colors.white))),
                      DropdownMenuItem(value: 'orange', child: Text('⚡ Orange City Sprinters (28)', style: TextStyle(fontSize: 12, color: Colors.white))),
                      DropdownMenuItem(value: 'msedcl', child: Text('🏢 MSEDCL Riders (45)', style: TextStyle(fontSize: 12, color: Colors.white))),
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
        const DynamicDensityMapView(
          title: 'Domain-Wide Dynamic Density Map',
          height: 310,
          showSosPins: true,
          isLeaderScope: false,
        ),
        const SizedBox(height: 14),

        // Live Crowd & Escort Telemetry
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.hub_rounded, size: 16, color: AppColors.domainCycling),
                  SizedBox(width: 8),
                  Text('DOMAIN TRAFFIC CONCENTRATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 10),
              _densityRow('🟣 Shankar Nagar Square', '450 Pax (Extreme Density - Choke Point)', AppColors.densityExtreme),
              _densityRow('🔵 Law College Square', '180 Pax (Moderate Density)', AppColors.densityModerate),
              _densityRow('🟢 Zero Mile Start Area', '65 Pax (Clearing / Sparse)', AppColors.densitySparse),
              const SizedBox(height: 12),
              const Divider(color: AppColors.borderSubtle, height: 1),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceHover,
                        foregroundColor: AppColors.sosRed,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      icon: const Icon(Icons.airport_shuttle_rounded, size: 14),
                      label: const Text('Track Ambulances (2)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ambulance #1 at Law College Sq, Ambulance #2 at Deekshabhoomi.')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceHover,
                        foregroundColor: AppColors.domainCycling,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 14),
                      label: const Text('Refresh (50ms)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _densityRow(String point, String status, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(point, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white))),
          Text(status, style: TextStyle(fontSize: 10, color: accent, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
