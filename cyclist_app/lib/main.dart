import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'core/services/mock_data_service.dart';
import 'features/admin/screens/superadmin_console_screen.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/developer/screens/developer_panel_screen.dart';
import 'features/leader/screens/group_leader_hub_screen.dart';
import 'features/participant/screens/group_creation_request_screen.dart';
import 'features/participant/screens/groups_management_screen.dart';
import 'features/participant/screens/user_home_screen.dart';
import 'features/police/screens/police_dashboard_screen.dart';
import 'features/profile/screens/user_profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VikasitNagpurApp());
}

class VikasitNagpurApp extends StatelessWidget {
  const VikasitNagpurApp({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        return MaterialApp(
          title: 'Vikasit Nagpur - Rally & Event Management Platform',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: service.themeMode,
          initialRoute: '/login',
          routes: {
            '/': (context) => const AuthScreen(),
            '/login': (context) => const AuthScreen(),
            '/home': (context) => const UserHomeScreen(),
            '/profile': (context) => const UserProfileScreen(),
            '/groups': (context) => const GroupsManagementScreen(),
            '/request-group': (context) => const GroupCreationRequestScreen(),
            '/leader': (context) => const GroupLeaderHubScreen(),
            '/admin': (context) => const SuperadminConsoleScreen(),
            '/police': (context) => const PoliceDashboardScreen(),
            '/dev-panel': (context) => const DeveloperPanelScreen(),
          },
        );
      },
    );
  }
}
