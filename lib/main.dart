import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inovasy_prototype/screens/onboarding/onboarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const InterviewApp());
}

class InterviewApp extends StatelessWidget {
  const InterviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
