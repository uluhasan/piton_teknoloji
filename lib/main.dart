import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // SharedPreferences için gerekli
  final isFirstLaunch = await checkFirstLaunch();
  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

Future<bool> checkFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final firstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (firstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
  }

  return firstLaunch;
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Podkes',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
