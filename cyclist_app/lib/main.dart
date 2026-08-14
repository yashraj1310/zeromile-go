import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'features/guest/screens/guest_home_screen.dart';
import 'features/auth/screens/phone_otp_screen.dart';
import 'features/participant/screens/participant_hub_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/marshal/screens/marshal_roster_screen.dart';
import 'features/police/screens/police_dashboard_screen.dart';
import 'features/watch/screens/smartwatch_hud_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VikasitNagpurApp());
}

class VikasitNagpurApp extends StatelessWidget {
  const VikasitNagpurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vikasit Nagpur',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const GuestHomeScreen(),
        '/auth': (context) => const PhoneOtpScreen(),
        '/participant': (context) => const ParticipantHubScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/marshal': (context) => const MarshalRosterScreen(),
        '/police': (context) => const PoliceDashboardScreen(),
        '/watch': (context) => const SmartwatchHudScreen(),
      },
    );
  }
}
