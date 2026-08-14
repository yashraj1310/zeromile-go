import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/sos_button.dart';

/// Page 4: Participant Live Event Hub (HERO SCREEN 1)
class ParticipantHubScreen extends StatefulWidget {
  const ParticipantHubScreen({super.key});

  @override
  State<ParticipantHubScreen> createState() => _ParticipantHubScreenState();
}

class _ParticipantHubScreenState extends State<ParticipantHubScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // Map Placeholder / Canvas Layer
          Container(
            color: const Color(0xFF0D1424),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, color: AppColors.cyanElectric, size: 48),
                  SizedBox(height: 8),
                  Text('Live Nagpur GPS Vector Map Canvas', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          // Top Telemetry HUD & Broadcast Ticker
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sports Telemetry Bar
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricBlock('SPEED', '24.5', 'km/h', AppColors.cyanElectric),
                        _buildMetricBlock('DISTANCE', '12.4', 'km', Colors.white),
                        _buildMetricBlock('PACE', '2:15', '/km', AppColors.emeraldNeon),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Live Broadcast Ticker Banner
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.radio, color: AppColors.cyanElectric, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Hydration Stop 2 open ahead at Law College Chowk!',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Floating SOS Button (Bottom Right)
          Positioned(
            bottom: 30,
            right: 20,
            child: SosButton(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.sosRed,
                    content: Text('🚨 Emergency SOS Triggered! Streaming GPS location to Admin & Police.', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
          // Bottom Left Navigation Shortcut to Admin / Police Demo
          Positioned(
            bottom: 30,
            left: 20,
            child: Row(
              children: [
                FloatingActionButton.small(
                  heroTag: 'admin_btn',
                  backgroundColor: AppColors.surfaceCard,
                  child: const Icon(Icons.admin_panel_settings, color: AppColors.cyanElectric),
                  onPressed: () => Navigator.pushNamed(context, '/admin'),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  heroTag: 'police_btn',
                  backgroundColor: AppColors.surfaceCard,
                  child: const Icon(Icons.local_police, color: AppColors.policeBlue),
                  onPressed: () => Navigator.pushNamed(context, '/police'),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  heroTag: 'watch_btn',
                  backgroundColor: AppColors.surfaceCard,
                  child: const Icon(Icons.watch, color: AppColors.emeraldNeon),
                  onPressed: () => Navigator.pushNamed(context, '/watch'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBlock(String label, String value, String unit, Color valColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTypography.telemetryLabel),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: AppTypography.telemetryValue.copyWith(color: valColor)),
            const SizedBox(width: 2),
            Text(unit, style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
