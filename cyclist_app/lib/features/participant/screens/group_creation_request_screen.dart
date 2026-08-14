import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';

class GroupCreationRequestScreen extends StatefulWidget {
  const GroupCreationRequestScreen({super.key});

  @override
  State<GroupCreationRequestScreen> createState() => _GroupCreationRequestScreenState();
}

class _GroupCreationRequestScreenState extends State<GroupCreationRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countController = TextEditingController();
  final _musterController = TextEditingController();
  final _notesController = TextEditingController();
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

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: const Text('NEW GROUP APPLICATION', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.domainCycling, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Applications are reviewed by Domain SuperAdmins. Upon approval, you will be appointed as Group Leader with full operational tools.',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 1. Group / Team Name
              const Text('1. Proposed Group / Team Name *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. Nagpur Citizen Front / VNIT Cyclists',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.surfaceCard,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Group name required' : null,
              ),
              const SizedBox(height: 16),

              // 2. Organization Category Dropdown
              const Text('2. Organization Category (Dropdown) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<OrgCategory>(
                    value: _selectedCategory,
                    dropdownColor: AppColors.surfaceCard,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: OrgCategory.ngoCivilSociety, child: Text('🌱 NGO / Civil Society Org', style: TextStyle(fontSize: 13, color: Colors.white))),
                      DropdownMenuItem(value: OrgCategory.collegeUnion, child: Text('🎓 College / University Union', style: TextStyle(fontSize: 13, color: Colors.white))),
                      DropdownMenuItem(value: OrgCategory.laborUnion, child: Text('⚒️ Labor Union / Trade Assoc', style: TextStyle(fontSize: 13, color: Colors.white))),
                      DropdownMenuItem(value: OrgCategory.corporateTeam, child: Text('🏢 Corporate / Workplace Team', style: TextStyle(fontSize: 13, color: Colors.white))),
                      DropdownMenuItem(value: OrgCategory.residentWelfareAssoc, child: Text('🏡 Resident Welfare Assoc (RWA)', style: TextStyle(fontSize: 13, color: Colors.white))),
                      DropdownMenuItem(value: OrgCategory.sportsClub, child: Text('⚡ Sports / Athletic Club', style: TextStyle(fontSize: 13, color: Colors.white))),
                      DropdownMenuItem(value: OrgCategory.schoolContingent, child: Text('🏫 School Contingent', style: TextStyle(fontSize: 13, color: Colors.white))),
                      DropdownMenuItem(value: OrgCategory.grassroots, child: Text('🤝 Grassroots / Independent', style: TextStyle(fontSize: 13, color: Colors.white))),
                    ],
                    onChanged: (cat) {
                      if (cat != null) setState(() => _selectedCategory = cat);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Estimated Contingent Size
              const Text('3. Estimated Contingent Size *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _countController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. 50 (Estimated participants count)',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.surfaceCard,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                validator: (val) => val == null || int.tryParse(val.trim()) == null ? 'Valid number required' : null,
              ),
              const SizedBox(height: 16),

              // 4. Proposed Assembly / Muster Point
              const Text('4. Proposed Assembly / Muster Point *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _musterController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. Samvidhan Square / Ambazari Lake Gate',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.surfaceCard,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Muster point required' : null,
              ),
              const SizedBox(height: 16),

              // 5. Leader Contact & Purpose Notes
              const Text('5. Leader Contact & Purpose Notes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Brief explanation of rally contingent purpose or special logistics needs...',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.surfaceCard,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.domainCycling,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                            const SnackBar(
                              backgroundColor: AppColors.domainCycling,
                              content: Text('🚀 Application submitted to Domain SuperAdmins for review!'),
                            ),
                          );
                        }
                      },
                child: const Text(
                  '🚀 SUBMIT APPLICATION FOR APPROVAL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
