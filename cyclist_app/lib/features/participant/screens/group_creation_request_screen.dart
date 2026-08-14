import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';

/// Screen 4: Universal Group Creation Request Modal (/request-group)
/// Features the 8-Category Organization Dropdown from PROJECT_PLAN.md
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

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    _musterController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = service.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : AppColors.textPrimaryLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'NEW GROUP APPLICATION',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Notice Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.domainCycling, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Applications are reviewed by Domain SuperAdmins. Upon approval, you will be appointed as Group Leader with full operational tools.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 1. Group / Team Name
              Text(
                '1. Proposed Group / Team Name *',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. Nagpur Citizen Front / VNIT Cyclists',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceCardDark : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.domainCycling, width: 1.5),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Group name required' : null,
              ),
              const SizedBox(height: 16),

              // 2. Organization Category (8 Orgs Dropdown)
              Text(
                '2. Organization Category (8 Categories Dropdown) *',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceCardDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<OrgCategory>(
                    value: _selectedCategory,
                    dropdownColor: isDark ? AppColors.surfaceCardDark : Colors.white,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.domainCycling),
                    items: [
                      _dropItem(OrgCategory.ngoCivilSociety, '🌱 NGO / Civil Society Org', isDark),
                      _dropItem(OrgCategory.collegeUnion, '🎓 College / University Union', isDark),
                      _dropItem(OrgCategory.laborUnion, '⚒️ Labor Union / Trade Assoc', isDark),
                      _dropItem(OrgCategory.corporateTeam, '🏢 Corporate / Workplace Team', isDark),
                      _dropItem(OrgCategory.residentWelfareAssoc, '🏡 Resident Welfare Assoc (RWA)', isDark),
                      _dropItem(OrgCategory.sportsClub, '⚡ Sports / Athletic Club', isDark),
                      _dropItem(OrgCategory.schoolContingent, '🏫 School Contingent', isDark),
                      _dropItem(OrgCategory.grassroots, '🤝 Grassroots / Independent', isDark),
                    ],
                    onChanged: (cat) {
                      if (cat != null) setState(() => _selectedCategory = cat);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Estimated Contingent Size
              Text(
                '3. Estimated Contingent Size *',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _countController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. 50 (Estimated participants count)',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceCardDark : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.domainCycling, width: 1.5),
                  ),
                ),
                validator: (val) => val == null || int.tryParse(val.trim()) == null ? 'Valid number required' : null,
              ),
              const SizedBox(height: 16),

              // 4. Proposed Assembly / Muster Point
              Text(
                '4. Proposed Assembly / Muster Point *',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _musterController,
                style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. Samvidhan Square / Ambazari Lake Gate',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceCardDark : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.domainCycling, width: 1.5),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Muster point required' : null,
              ),
              const SizedBox(height: 16),

              // 5. Leader Contact & Purpose Notes
              Text(
                '5. Leader Contact & Purpose Notes',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Brief explanation of rally contingent purpose or special logistics needs...',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceCardDark : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.domainCycling, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.domainCycling,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: _submitted
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _submitted = true);
                          final req = GroupCreationRequest(
                            id: 'req-${DateTime.now().millisecondsSinceEpoch}',
                            domainId: service.currentDomain.id,
                            applicantName: 'Rajesh Sharma',
                            applicantPhone: '+91 98230-12345',
                            orgName: _nameController.text.trim(),
                            orgCategory: _selectedCategory,
                            expectedCount: int.parse(_countController.text.trim()),
                            musterPoint: _musterController.text.trim(),
                            leaderNotes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
                            createdAt: DateTime.now(),
                          );
                          service.submitGroupRequest(req);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.domainCycling,
                              content: Text(
                                '🚀 Application for "${_nameController.text.trim()}" submitted to SuperAdmins for review!',
                                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                      },
                child: const Text(
                  '🚀 SUBMIT APPLICATION FOR APPROVAL',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<OrgCategory> _dropItem(OrgCategory cat, String label, bool isDark) {
    return DropdownMenuItem(
      value: cat,
      child: Text(
        label,
        style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppColors.textPrimaryLight, fontWeight: FontWeight.w600),
      ),
    );
  }
}
