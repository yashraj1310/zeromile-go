import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';

/// Screen 4: Universal Group Creation Request Modal (/request-group)
/// Features 8-Category Dropdown, Blue/Purple/Green Category Coding, Nagpur Landmark Assembly Presets, and Dual Theme.
class GroupCreationRequestScreen extends StatefulWidget {
  const GroupCreationRequestScreen({super.key});

  @override
  State<GroupCreationRequestScreen> createState() => _GroupCreationRequestScreenState();
}

class _GroupCreationRequestScreenState extends State<GroupCreationRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Nagpur Citizen Front');
  final _countController = TextEditingController(text: '75');
  final _musterController = TextEditingController(text: 'Samvidhan Square, Nagpur');
  final _notesController = TextEditingController(text: 'Civic awareness contingent with 75 registered participants.');
  OrgCategory _selectedCategory = OrgCategory.ngoCivilSociety;
  bool _submitted = false;

  final List<String> _musterPresets = [
    'Samvidhan Square',
    'Zero Mile Stone',
    'VNIT Campus Gate',
    'Futala Promenade',
    'Shankar Nagar Square',
    'Civil Lines GPO',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    _musterController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(OrgCategory cat) {
    switch (cat) {
      case OrgCategory.collegeUnion:
      case OrgCategory.schoolContingent:
        return AppColors.royalBlue;
      case OrgCategory.ngoCivilSociety:
      case OrgCategory.grassroots:
        return AppColors.royalPurple;
      case OrgCategory.sportsClub:
      case OrgCategory.residentWelfareAssoc:
        return AppColors.emeraldGreen;
      case OrgCategory.corporateTeam:
      case OrgCategory.laborUnion:
        return AppColors.solarOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final catColor = _getCategoryColor(_selectedCategory);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 68,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textCol),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'NEW CONTINGENT APPLICATION',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14.5,
            letterSpacing: 0.4,
            color: textCol,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Photo Hero Banner
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1517649763962-0c623266ddc0?auto=format&fit=crop&w=800&q=80'),
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
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.royalPurple,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'OFFICIAL REGISTRATION',
                                  style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Form a Verified Nagpur Contingent',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Info Notice Banner
                  GlassCard(
                    padding: const EdgeInsets.all(14),
                    borderColor: catColor.withValues(alpha: 0.4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: catColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.verified_user_rounded, color: catColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SUPERADMIN VERIFICATION WORKFLOW',
                                style: TextStyle(
                                  color: textCol,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Applications are vetted by City SuperAdmins. Approved contingents receive unique muster codes and dedicated Leader Hub access.',
                                style: TextStyle(fontSize: 11, color: textMuted, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 3. Organization Category Dropdown Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ORGANIZATION CATEGORY *',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _selectedCategory.name.toUpperCase(),
                                style: TextStyle(color: catColor, fontSize: 9.5, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: bgElevated,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderCol),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<OrgCategory>(
                              value: _selectedCategory,
                              dropdownColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down_rounded, color: catColor),
                              items: OrgCategory.values.map((cat) {
                                final color = _getCategoryColor(cat);
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Row(
                                    children: [
                                      CircleAvatar(radius: 4, backgroundColor: color),
                                      const SizedBox(width: 8),
                                      Text(
                                        cat.name,
                                        style: TextStyle(fontSize: 13, color: textCol, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedCategory = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 4. Contingent Details Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONTINGENT NAME *',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(fontSize: 13.5, color: textCol, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            hintText: 'e.g. Nagpur Runners Collective',
                            filled: true,
                            fillColor: bgElevated,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          validator: (v) => v == null || v.isEmpty ? 'Please enter group name' : null,
                        ),
                        const SizedBox(height: 14),

                        Text(
                          'ESTIMATED CONTINGENT STRENGTH (MEMBERS) *',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _countController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 13.5, color: textCol, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.people_outline_rounded, size: 18, color: AppColors.royalBlue),
                            hintText: 'e.g. 50',
                            filled: true,
                            fillColor: bgElevated,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 14),

                        Text(
                          'PROPOSED MUSTER ASSEMBLY LOCATION *',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _musterController,
                          style: TextStyle(fontSize: 13.5, color: textCol, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.place_rounded, size: 18, color: AppColors.solarOrange),
                            hintText: 'e.g. Samvidhan Square, Nagpur',
                            filled: true,
                            fillColor: bgElevated,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Preset chips
                        Text(
                          'Quick Presets:',
                          style: TextStyle(fontSize: 10.5, color: textMuted, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _musterPresets.map((preset) {
                            return ActionChip(
                              backgroundColor: bgElevated,
                              side: BorderSide(color: borderCol),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              label: Text(
                                preset,
                                style: TextStyle(fontSize: 10.5, color: textCol, fontWeight: FontWeight.w700),
                              ),
                              onPressed: () {
                                setState(() {
                                  _musterController.text = '$preset, Nagpur';
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 5. Purpose & Notes Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ADDITIONAL MISSION NOTES (OPTIONAL)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          style: TextStyle(fontSize: 13, color: textCol),
                          decoration: InputDecoration(
                            hintText: 'Describe contingent purpose, special requirements, or marshalling points...',
                            filled: true,
                            fillColor: bgElevated,
                            contentPadding: const EdgeInsets.all(14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 6. Submit Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: catColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: Text(
                      _submitted ? '✓ APPLICATION SUBMITTED' : 'SUBMIT CONTINGENT APPLICATION',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
                    ),
                    onPressed: _submitted
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final count = int.tryParse(_countController.text) ?? 50;
                              service.requestGroupCreation(
                                name: _nameController.text.trim(),
                                orgCategory: _selectedCategory,
                                estimatedCount: count,
                                musterPoint: _musterController.text.trim(),
                                applicantName: 'Applicant (Group Leader)',
                                applicantPhone: '9822000000',
                              );

                              setState(() => _submitted = true);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.royalPurple,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  content: Text(
                                    '✓ Contingent "${_nameController.text}" submitted to City SuperAdmins!',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );

                              Future.delayed(const Duration(seconds: 1), () {
                                if (mounted) Navigator.pop(context);
                              });
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
