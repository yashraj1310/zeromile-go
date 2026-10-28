import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/mock_data_service.dart';
import '../widgets/nagpur_map_background.dart';

/// Citizen Auth Screen: Phone Number & OTP Verification / Registration
/// Featuring Blurred Nagpur Map & City Skyline Hero Background, Dual Theme, and Clean Glass Card.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  final _emergencyController = TextEditingController();
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
        SnackBar(
          backgroundColor: AppColors.sosRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text('Please enter a valid 10-digit mobile number'),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _otpSent = true;
        _otpController.text = '123456';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.solarOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text('🔑 Demo OTP sent: 123456 (Auto-filled)'),
        ),
      );
    });
  }

  void _handleVerifyAndLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _handleQuickRoleLogin(String roleTitle, String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.solarOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('Logged in as $roleTitle!'),
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final cardBg = isDark ? const Color(0xE61A1A2E) : const Color(0xF2FFFFFF);
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Authentic Blurred Nagpur Map Background
          Positioned.fill(
            child: NagpurMapBackground(isDark: isDark),
          ),

          // 3. Top Theme Switcher
          Positioned(
            top: 45,
            right: 20,
            child: IconButton(
              tooltip: service.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderCol),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  service.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: service.isDarkMode ? AppColors.sunnyGold : AppColors.policeBlue,
                  size: 18,
                ),
              ),
              onPressed: () => service.toggleTheme(),
            ),
          ),

          // 4. Center Content Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Header
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.royalBlue, AppColors.royalPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.royalPurple.withValues(alpha: 0.45),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.directions_bike_rounded, size: 36, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'VIKASIT NAGPUR',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: textCol,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Multi-Tenant Rally & Civic Event Management Platform',
                      style: TextStyle(fontSize: 12, color: textMuted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Frosted Glass Form Card
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: AppColors.royalPurple.withValues(alpha: 0.35), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Tab Bar
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.royalBlue, AppColors.royalPurple],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.royalPurple.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: textMuted,
                              labelStyle: AppTypography.chipLabel().copyWith(fontWeight: FontWeight.w900, fontSize: 11.5),
                              tabs: const [
                                Tab(text: '📱 Mobile Login'),
                                Tab(text: '✨ Citizen Pass'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: _tabController.index == 0 ? (_otpSent ? 285 : 240) : 275,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // TAB 1: PHONE & OTP LOGIN
                                SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Mobile Number *',
                                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: textCol),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        style: TextStyle(fontSize: 14, color: textCol, fontWeight: FontWeight.w700),
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.phone_android_rounded, size: 18, color: AppColors.royalBlue),
                                          hintText: 'Enter 10-digit mobile number',
                                          filled: true,
                                          fillColor: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      if (_otpSent) ...[
                                        Text(
                                          'Verification OTP Code *',
                                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: textCol),
                                        ),
                                        const SizedBox(height: 6),
                                        TextField(
                                          controller: _otpController,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(fontSize: 14, color: textCol, fontWeight: FontWeight.w800, letterSpacing: 2),
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.vibrantEmerald),
                                            hintText: '6-digit OTP',
                                            filled: true,
                                            fillColor: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                      ] else ...[
                                        const SizedBox(height: 16),
                                      ],

                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.royalBlue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 13),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                          elevation: 2,
                                        ),
                                        onPressed: _isLoading ? null : (_otpSent ? _handleVerifyAndLogin : _handleSendOtp),
                                        child: Text(
                                          _isLoading
                                              ? 'PLEASE WAIT...'
                                              : (_otpSent ? 'VERIFY OTP & ENTER HUD' : 'GET VERIFICATION OTP'),
                                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // TAB 2: CITIZEN REGISTRATION
                                SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Full Citizen Name *',
                                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: textCol),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: _nameController,
                                        style: TextStyle(fontSize: 13.5, color: textCol, fontWeight: FontWeight.w700),
                                        decoration: InputDecoration(
                                          hintText: 'e.g. Enter full name',
                                          filled: true,
                                          fillColor: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: TextField(
                                              controller: _emergencyController,
                                              keyboardType: TextInputType.phone,
                                              style: TextStyle(fontSize: 13, color: textCol),
                                              decoration: InputDecoration(
                                                hintText: 'Emergency phone',
                                                filled: true,
                                                fillColor: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _selectedBloodGroup,
                                                  dropdownColor: cardBg,
                                                  isExpanded: true,
                                                  items: _bloodGroups.map((bg) {
                                                    return DropdownMenuItem(
                                                      value: bg,
                                                      child: Text(
                                                        bg,
                                                        style: TextStyle(color: textCol, fontWeight: FontWeight.w800, fontSize: 12),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (val) {
                                                    if (val != null) setState(() => _selectedBloodGroup = val);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),

                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.royalPurple,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 13),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                          elevation: 2,
                                        ),
                                        onPressed: _handleVerifyAndLogin,
                                        child: const Text(
                                          'REGISTER & GENERATE PASS',
                                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick Demo Roles Access
                    Row(
                      children: [
                        Expanded(child: Divider(color: borderCol)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '⚡ 1-TAP ROLE DEMO ACCESS',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: textMuted, letterSpacing: 0.8),
                          ),
                        ),
                        Expanded(child: Divider(color: borderCol)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _demoButton('🚴 Participant Home', '/home', AppColors.solarOrange),
                        _demoButton('👔 Group Leader Hub', '/leader', AppColors.vibrantEmerald),
                        _demoButton('👮 Traffic Police', '/police', AppColors.policeBlue),
                        _demoButton('🛡️ SuperAdmin', '/admin', AppColors.sosRed),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _demoButton(String label, String route, Color accent) {
    return ActionChip(
      backgroundColor: accent.withValues(alpha: 0.15),
      side: BorderSide(color: accent.withValues(alpha: 0.4)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      label: Text(
        label,
        style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 11),
      ),
      onPressed: () => _handleQuickRoleLogin(label, route),
    );
  }
}
