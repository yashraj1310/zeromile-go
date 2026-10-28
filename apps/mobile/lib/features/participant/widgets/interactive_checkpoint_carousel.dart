import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class InteractiveCheckpointCarousel extends StatelessWidget {
  const InteractiveCheckpointCarousel({super.key});

  final List<Map<String, dynamic>> _checkpoints = const [
    {
      'name': 'Zero Mile Stone',
      'type': 'Origin & Start Gate',
      'distance': '0.0 km',
      'isPassed': true,
      'status': 'PASSED (06:02 AM)',
      'accent': AppColors.royalBlue,
      'icon': Icons.flag_rounded,
      'amenities': ['Timing Mat', 'Police Escort', 'Water Dispenser'],
      'marshals': 'Officer Deshmukh • VHF Ch 2',
    },
    {
      'name': 'Shankar Nagar Sq',
      'type': 'Water & Electrolyte Station',
      'distance': '2.1 km away',
      'isPassed': false,
      'status': 'APPROACHING',
      'accent': AppColors.solarOrange,
      'icon': Icons.water_drop_rounded,
      'amenities': ['Electrolytes', 'First Aid', 'Puncture Repair'],
      'marshals': 'Nagpur Cyclists Club Volunteers',
    },
    {
      'name': 'Law College Square',
      'type': 'Medical & Paramedic Post',
      'distance': '4.8 km away',
      'isPassed': false,
      'status': 'UPCOMING',
      'accent': AppColors.royalPurple,
      'icon': Icons.local_hospital_rounded,
      'amenities': ['Ambulance 04', 'Physio Stretch Zone', 'Glucose Bars'],
      'marshals': 'GMC Medical Team',
    },
    {
      'name': 'Deekshabhoomi Arc',
      'type': 'Intermediate Sprint & Media Point',
      'distance': '8.6 km away',
      'isPassed': false,
      'status': 'UPCOMING',
      'accent': AppColors.royalPurple,
      'icon': Icons.camera_alt_rounded,
      'amenities': ['Official Photo Spot', 'Timing Mat 2', 'Mechanical Van'],
      'marshals': 'Civic Event Organizers',
    },
    {
      'name': 'Futala Lake Promenade',
      'type': 'Finish Pavilion & Medal Distribution',
      'distance': '24.5 km away',
      'isPassed': false,
      'status': 'FINAL DESTINATION',
      'accent': AppColors.vibrantEmerald,
      'icon': Icons.emoji_events_rounded,
      'amenities': ['Medals & Refreshments', 'Recovery Zone', 'Live Screen'],
      'marshals': 'SuperAdmin Command Central',
    },
  ];

  void _showCheckpointDetails(BuildContext context, Map<String, dynamic> cp) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(
            color: (cp['accent'] as Color).withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (cp['accent'] as Color).withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (cp['accent'] as Color).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: (cp['accent'] as Color).withValues(alpha: 0.4)),
                  ),
                  child: Icon(cp['icon'] as IconData, color: cp['accent'] as Color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cp['name'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: textCol,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cp['type'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: cp['accent'] as Color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AVAILABLE AMENITIES & LOGISTICS:',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      color: textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (cp['amenities'] as List<String>)
                        .map((amenity) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: (cp['accent'] as Color).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: (cp['accent'] as Color).withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                '✓ $amenity',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cp['accent'] as Color,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cp['accent'] as Color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Dismiss Details',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.fmd_good_rounded, color: AppColors.royalBlue, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'COURSE CHECKPOINTS & AID STATIONS',
                      style: TextStyle(
                        color: textCol,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '5 Total Posts',
              style: TextStyle(
                color: AppColors.royalPurple,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _checkpoints.length,
            itemBuilder: (context, index) {
              final cp = _checkpoints[index];
              final isPassed = cp['isPassed'] as bool;
              final accent = cp['accent'] as Color;

              return InkWell(
                onTap: () => _showCheckpointDetails(context, cp),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isPassed ? AppColors.vibrantEmerald.withValues(alpha: 0.6) : borderCol,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(cp['icon'] as IconData, color: accent, size: 14),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? AppColors.vibrantEmerald.withValues(alpha: 0.15)
                                  : (isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isPassed ? 'CLEARED' : cp['distance'] as String,
                              style: TextStyle(
                                color: isPassed ? AppColors.vibrantEmerald : textMuted,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cp['name'] as String,
                            style: TextStyle(
                              color: textCol,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            cp['type'] as String,
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic);
  }
}
