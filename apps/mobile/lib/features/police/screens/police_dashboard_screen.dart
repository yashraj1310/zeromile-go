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
  bool _greenCorridorActive = true;

  final Map<String, bool> _junctionClosed = {
    'Shankar Nagar Square': true,
    'Law College Square': false,
    'Zero Mile Stone Cross': true,
    'Futala Waterfront Point': false,
  };

  @override
  void dispose() {
    _advisoryController.dispose();
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
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: const UniversalNavDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 76,
            titleSpacing: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: textCol,
                ),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TRAFFIC POLICE COMMAND',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                            fontSize: 13.5,
                            color: textCol,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Nagpur City Police • Green Corridor',
                          style: TextStyle(
                            color: AppColors.royalBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.royalBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.royalBlue.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 3.5, backgroundColor: _greenCorridorActive ? AppColors.vibrantEmerald : AppColors.sosRed),
                        const SizedBox(width: 5),
                        Text(
                          _greenCorridorActive ? 'CORRIDOR ACTIVE' : 'CORRIDOR OFF',
                          style: TextStyle(
                            color: _greenCorridorActive ? AppColors.vibrantEmerald : AppColors.sosRed,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                children: [
                  // 1. Photo Hero Banner with Green Corridor Status
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1541625602330-2277a4c46182?auto=format&fit=crop&w=800&q=80'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.88),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.royalBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'CITIZEN RALLY TRAFFIC CORRIDOR',
                                  style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Zero Mile to Ambazari Green Passage',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          Switch(
                            value: _greenCorridorActive,
                            activeTrackColor: AppColors.vibrantEmerald,
                            onChanged: (val) {
                              setState(() => _greenCorridorActive = val);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: val ? AppColors.vibrantEmerald : AppColors.sosRed,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(val ? '🟢 Green Corridor Activated across 4 Junctions' : '🔴 Green Corridor Deactivated'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Operational Scope Information Card
                  GlassCard(
                    padding: const EdgeInsets.all(14),
                    borderColor: AppColors.royalBlue.withValues(alpha: 0.35),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.royalBlue.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.shield_rounded, color: AppColors.royalBlue, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'POLICE SCOPE: Traffic regulation, junction holding & vehicle diversions. (Participant medical emergencies are handled by SuperAdmin Dispatch).',
                            style: TextStyle(
                              color: textCol,
                              fontSize: 11,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Live Junction Clearance Status
                  GlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.traffic_rounded, size: 18, color: AppColors.royalBlue),
                                const SizedBox(width: 8),
                                Text(
                                  'NAGPUR JUNCTION CLEARANCES',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: textCol,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.vibrantEmerald.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '4 MONITORED',
                                style: TextStyle(color: AppColors.vibrantEmerald, fontSize: 9.5, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        _junctionCard(
                          context,
                          name: 'Shankar Nagar Square',
                          status: 'Lead Contingent Approaching',
                          eta: '03:45 mins ETA',
                          isClosed: _junctionClosed['Shankar Nagar Square'] ?? true,
                          onToggle: () {
                            setState(() {
                              _junctionClosed['Shankar Nagar Square'] = !(_junctionClosed['Shankar Nagar Square'] ?? true);
                            });
                          },
                          bgElevated: bgElevated,
                          borderCol: borderCol,
                          textCol: textCol,
                          textMuted: textMuted,
                        ),
                        const SizedBox(height: 10),

                        _junctionCard(
                          context,
                          name: 'Zero Mile Stone Cross',
                          status: 'Corridor Hold Engaged',
                          eta: 'Passed / Monitoring Rear',
                          isClosed: _junctionClosed['Zero Mile Stone Cross'] ?? true,
                          onToggle: () {
                            setState(() {
                              _junctionClosed['Zero Mile Stone Cross'] = !(_junctionClosed['Zero Mile Stone Cross'] ?? true);
                            });
                          },
                          bgElevated: bgElevated,
                          borderCol: borderCol,
                          textCol: textCol,
                          textMuted: textMuted,
                        ),
                        const SizedBox(height: 10),

                        _junctionCard(
                          context,
                          name: 'Law College Square',
                          status: 'Open for Public Vehicles',
                          eta: '18:20 mins ETA',
                          isClosed: _junctionClosed['Law College Square'] ?? false,
                          onToggle: () {
                            setState(() {
                              _junctionClosed['Law College Square'] = !(_junctionClosed['Law College Square'] ?? false);
                            });
                          },
                          bgElevated: bgElevated,
                          borderCol: borderCol,
                          textCol: textCol,
                          textMuted: textMuted,
                        ),
                        const SizedBox(height: 10),

                        _junctionCard(
                          context,
                          name: 'Futala Waterfront Point',
                          status: 'Assembly Zone - Free Flow',
                          eta: 'Finish Line Hub',
                          isClosed: _junctionClosed['Futala Waterfront Point'] ?? false,
                          onToggle: () {
                            setState(() {
                              _junctionClosed['Futala Waterfront Point'] = !(_junctionClosed['Futala Waterfront Point'] ?? false);
                            });
                          },
                          bgElevated: bgElevated,
                          borderCol: borderCol,
                          textCol: textCol,
                          textMuted: textMuted,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Live Map View Container
                  Container(
                    height: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderCol),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: const DynamicDensityMapView(
                      title: 'Nagpur Traffic Control Live Density Map',
                      height: 270,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Public Traffic Advisory Broadcast Tool
                  GlassCard(
                    padding: const EdgeInsets.all(18),
                    borderColor: AppColors.royalBlue.withValues(alpha: 0.35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.royalBlue.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.campaign_rounded, color: AppColors.royalBlue, size: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'BROADCAST TRAFFIC ADVISORY TO CITIZENS',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                color: textCol,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _advisoryController,
                          maxLines: 2,
                          style: TextStyle(fontSize: 13, color: textCol),
                          decoration: InputDecoration(
                            hintText: 'e.g. Shankar Nagar Flyover closed for 20 mins due to rally passage. Use North Ring diversion.',
                            filled: true,
                            fillColor: bgElevated,
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.royalBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          icon: const Icon(Icons.send_rounded, size: 16),
                          label: const Text(
                            'PUSH ADVISORY TO ALL EVENT FEEDS',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                          onPressed: () {
                            if (_advisoryController.text.trim().isNotEmpty) {
                              service.publishBroadcast(
                                text: _advisoryController.text.trim(),
                                isGeneral: true,
                              );
                              _advisoryController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: AppColors.royalBlue,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('✓ Traffic advisory published to all participant feeds!'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _junctionCard(
    BuildContext context, {
    required String name,
    required String status,
    required String eta,
    required bool isClosed,
    required VoidCallback onToggle,
    required Color bgElevated,
    required Color borderCol,
    required Color textCol,
    required Color textMuted,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isClosed ? AppColors.sosRed.withValues(alpha: 0.4) : borderCol),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textCol),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    CircleAvatar(radius: 3, backgroundColor: isClosed ? AppColors.sosRed : AppColors.vibrantEmerald),
                    const SizedBox(width: 5),
                    Text(
                      status,
                      style: TextStyle(fontSize: 11, color: isClosed ? AppColors.sosRed : AppColors.vibrantEmerald, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Text(
                  eta,
                  style: TextStyle(fontSize: 10.5, color: textMuted),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isClosed ? AppColors.sosRed : AppColors.royalBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 1,
            ),
            onPressed: onToggle,
            child: Text(
              isClosed ? 'Hold Traffic' : 'Open Lane',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
