import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

/// Page 6: Safety Marshal & Group Leader Screen
class MarshalRosterScreen extends StatelessWidget {
  const MarshalRosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Text('Safety Marshal - Sub-Pack #3', style: AppTypography.h3),
        backgroundColor: AppColors.surfaceCard,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sub-pack status bar
          GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Active', '18', AppColors.emeraldNeon),
                _buildStat('Lagging', '2', AppColors.amberNeon),
                _buildStat('SOS', '0', AppColors.sosRed),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Assigned Members (20 Cyclists)', style: AppTypography.h3),
          const SizedBox(height: 10),
          _buildMemberTile('Amit Verma', '12.2 km covered', '95% Batt', AppColors.emeraldNeon),
          _buildMemberTile('Priya Sharma', '11.4 km (300m behind pack)', '82% Batt', AppColors.amberNeon),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }

  Widget _buildMemberTile(String name, String sub, String batt, Color statusColor) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: statusColor.withOpacity(0.2), child: Icon(Icons.person, color: statusColor, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text(batt, style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
