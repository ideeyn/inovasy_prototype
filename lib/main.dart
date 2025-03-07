import 'package:flutter/material.dart';
import 'package:inovasy_prototype/screens/index/report/report.dart';

void main() {
  runApp(const InterviewApp());
}

class InterviewApp extends StatelessWidget {
  const InterviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReportScreen(),
    );
  }
}
