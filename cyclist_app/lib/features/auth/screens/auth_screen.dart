import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';

/// Citizen Auth Screen: Phone Number & OTP Verification / Registration
/// Matching PROJECT_PLAN.md Section 1 & 4 specifications.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _phoneController = TextEditingController(text: '9823012345');
  final _otpController = TextEditingController();
  final _nameController = TextEditingController(text: 'Yashraj Sharma');
  final _emergencyController = TextEditingController(text: '9823099999');
  String _selectedBloodGroup = 'O+';
  bool _otpSent = false;
  bool _isLoading = false;

  final List<String> _bloodGroups = ['O+', 'A+', 'B+', 'AB+', 'O-', 'A-', 'B-', 'AB-'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    if (_phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.sosRed,
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _isLoading = false;
        _otpSent = true;
        _otpController.text = '123456'; // Pre-fill demo OTP
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.domainCycling,
          content: Text('🔑 Demo OTP sent: 123456 (Auto-filled)'),
        ),
      );
    });
  }

  void _handleVerifyAndLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _handleQuickRoleLogin(String roleTitle, String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.domainCycling,
        content: Text('Logged in as $roleTitle!'),
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = service.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Brand Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.domainCycling, Color(0xFF4FACFE)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.domainCycling.withValues(alpha: 0.4),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.location_city_rounded, size: 36, color: Color(0xFF060911)),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'VIKASIT NAGPUR',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Smart City Rally & Civic Event Platform',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Login / Signup Tabs
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceCardDark : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppColors.domainCycling,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.black87,
                    unselectedLabelColor: isDark ? AppColors.textMuted : AppColors.textSecondaryLight,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    tabs: const [
                      Tab(text: '📱 Mobile Login'),
                      Tab(text: '✨ New Citizen Signup'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form Container
                Container(
                  height: 340,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceCardDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // TAB 1: MOBILE OTP LOGIN
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enter Mobile Number',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Phone Input
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                                  ),
                                  child: const Text('🇮🇳 +91', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 14, fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: '98230 XXXXX',
                                      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                                      filled: true,
                                      fillColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // OTP Input (if sent)
                            if (_otpSent) ...[
                              Text(
                                'Enter 6-Digit OTP Code',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 8, color: AppColors.domainCycling),
                                decoration: InputDecoration(
                                  hintText: '••••••',
                                  filled: true,
                                  fillColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            // Action Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.domainCycling,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : (_otpSent ? _handleVerifyAndLogin : _handleSendOtp),
                              child: Text(
                                _isLoading
                                    ? 'PLEASE WAIT...'
                                    : (_otpSent ? 'VERIFY OTP & ENTER APP' : 'GET OTP VERIFICATION CODE'),
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // TAB 2: CITIZEN REGISTRATION
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Full Citizen Name *',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _nameController,
                              style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'e.g. Yashraj Sharma',
                                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                filled: true,
                                fillColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Emergency Next-of-Kin *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight)),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: _emergencyController,
                                        keyboardType: TextInputType.phone,
                                        style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 13),
                                        decoration: InputDecoration(
                                          hintText: '98230 XXXXX',
                                          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                          filled: true,
                                          fillColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Blood Group', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight)),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _selectedBloodGroup,
                                            dropdownColor: isDark ? const Color(0xFF131B2E) : Colors.white,
                                            isExpanded: true,
                                            items: _bloodGroups.map((bg) {
                                              return DropdownMenuItem(
                                                value: bg,
                                                child: Text(bg, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight)),
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              if (val != null) setState(() => _selectedBloodGroup = val);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.domainCycling,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _handleVerifyAndLogin,
                              child: const Text('REGISTER & GENERATE RALLY PASS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Hackathon Judge Quick Demo Logins
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.borderSubtleDark, height: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'JUDGE 1-TAP DEMO ACCESS',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 1),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.borderSubtleDark, height: 1)),
                  ],
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _demoButton('🚴 Participant Home', '/home', AppColors.domainCycling),
                    _demoButton('👔 Group Leader Hub', '/leader', AppColors.domainMarathon),
                    _demoButton('👮 Traffic Police', '/police', AppColors.policeBlue),
                    _demoButton('🛡️ SuperAdmin Console', '/admin', AppColors.sosRed),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _demoButton(String label, String route, Color accent) {
    return ActionChip(
      backgroundColor: accent.withValues(alpha: 0.12),
      side: BorderSide(color: accent.withValues(alpha: 0.4)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      label: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accent),
      ),
      onPressed: () => _handleQuickRoleLogin(label, route),
    );
  }
}
