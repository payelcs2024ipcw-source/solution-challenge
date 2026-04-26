import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/volunteer/login_screen.dart';
import 'screens/volunteer/profile_screen.dart';
import 'screens/volunteer/tasks_screen.dart';
import 'screens/volunteer/chatbot_screen.dart';
import 'screens/volunteer/map_screen.dart';
import 'screens/ngo/ngo_login_screen.dart';
import 'screens/ngo/ngo_dashboard.dart';
import 'screens/ngo/submit_need_screen.dart';
import 'screens/ngo/ngo_maps_screen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volunteer Connect',
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      elevation: 0,
     ),
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  ),
      initialRoute: '/volunteer/login',
      routes: {
        '/volunteer/login': (_) => const VolunteerLoginScreen(),
        '/volunteer/profile': (_) => const VolunteerProfileScreen(),
        '/volunteer/tasks': (_) => const TasksScreen(),
        '/volunteer/chatbot': (_) => const ChatbotScreen(),
        '/volunteer/map': (_) => const MapScreen(),
        '/': (_) => const NgoLoginScreen(),
        '/ngo-dashboard': (_) => const NgoDashboard(),
        '/submit-need': (_) => const SubmitNeedScreen(),
        '/ngo-map': (_) => const NgoMapScreen(),
      },
    );
  }
}

