import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/volunteer/login_screen.dart';
import 'screens/volunteer/profile_screen.dart';
import 'screens/volunteer/tasks_screen.dart';

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
      initialRoute: '/volunteer/login',
      routes: {
        '/volunteer/login': (_) => const VolunteerLoginScreen(),
        '/volunteer/profile': (_) => const VolunteerProfileScreen(),
        '/volunteer/tasks': (_) => const TasksScreen(),
      },
    );
  }
}