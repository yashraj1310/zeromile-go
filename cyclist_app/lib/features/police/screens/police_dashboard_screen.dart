import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/dynamic_density_map_view.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/universal_nav_drawer.dart';

class PoliceDashboardScreen extends StatefulWidget {
  const PoliceDashboardScreen({super.key});

  @override
  State<PoliceDashboardScreen> createState() => _PoliceDashboardScreenState();
}

class _PoliceDashboardScreenState extends State<PoliceDashboardScreen> {
  final _advisoryController = TextEditingController();

  @override
  void dispose() {
    _advisoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          drawer: const UniversalNavDrawer(),
          appBar: AppBar(
            backgroundColor: AppColors.bgPrimary,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TRAFFIC POLICE COMMAND CENTER', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Nagpur City Traffic Control • Green Corridor Ops', style: TextStyle(fontSize: 10, color: AppColors.policeBlue)),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Critical Operational Scope Banner (SOS IS NOT SENT TO POLICE)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0x332979FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.policeBlue.withOpacity(0.5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_rounded, color: AppColors.policeBlue, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'ℹ️ POLICE OPERATIONAL SCOPE: Traffic regulation, green corridors & junction clearances. (Participant SOS emergencies are isolated and handled by Event Medical Dispatch & SuperAdmin triage).',
                        style: TextStyle(fontSize: 11, color: Colors.white, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 2. Junction Arrival Predictions & Dynamic Road Clearance
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.traffic_rounded, size: 16, color: AppColors.policeBlue),
                            SizedBox(width: 8),
                            Text('JUNCTION ARRIVAL PREDICTIONS & ETAs', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                          ],
                        ),
                        Text('Dynamic Green Corridors', style: TextStyle(fontSize: 10, color: AppColors.domainMarathon, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _junctionCard(
                      name: 'Shankar Nagar Square',
                      status: 'Lead Pack Approaching',
                      eta: '03:45 mins',
                      action: 'Close North Lane',
                      isUrgent: true,
                    ),
                    const SizedBox(height: 8),

                    _junctionCard(
                      name: 'Law College Square',
                      status: 'Clear for Public Vehicles',
                      eta: '18:20 mins',
                      action: 'Hold Traffic at 15m',
                      isUrgent: false,
                    ),
                    const SizedBox(height: 8),

                    _junctionCard(
                      name: 'Deekshabhoomi Finish Approach',
                      status: 'Corridor Prepared',
                      eta: '34:10 mins',
                      action: 'Maintain Flow',
                      isUrgent: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 3. Domain Traffic Density Viewport
              const DynamicDensityMapView(
                title: 'Traffic Police Live Congestion Map',
                height: 240,
                showSosPins: false, // SOS is hidden from police view
              ),

              const SizedBox(height: 14),

              // 4. Police Advisory Broadcast Composer
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.campaign_rounded, size: 16, color: AppColors.policeBlue),
                        SizedBox(width: 8),
                        Text('PUBLISH TRAFFIC ADVISORY TO CITIZENS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _advisoryController,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'e.g. 📢 Wardha Road Flyover clear for traffic. Avoid WHC road till 10:00 AM.',
                        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                        filled: true,
                        fillColor: AppColors.surfaceCard,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.policeBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 14),
                      label: const Text('Publish Police Advisory', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final text = _advisoryController.text.trim();
                        if (text.isNotEmpty) {
                          service.addPoliceAdvisory(text);
                          _advisoryController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✓ Traffic advisory broadcasted to Public Web & Citizen Apps!')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 5. Active Advisories Feed
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ACTIVE POLICE TRAFFIC ADVISORIES:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    ...service.policeAdvisories.map((advisory) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(advisory, style: const TextStyle(fontSize: 11, color: Colors.white, height: 1.3)),
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _junctionCard({
    required String name,
    required String status,
    required String eta,
    required String action,
    required bool isUrgent,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceHover,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isUrgent ? AppColors.sosRed.withOpacity(0.5) : AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text(status, style: TextStyle(fontSize: 10, color: isUrgent ? AppColors.warningAmber : AppColors.domainMarathon)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('ETA: $eta', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.domainCycling, fontFamily: 'monospace')),
              const SizedBox(height: 4),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUrgent ? AppColors.sosRed : AppColors.surfaceCard,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: Text(action, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
