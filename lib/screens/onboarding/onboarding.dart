import 'package:flutter/material.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/screens/index/report/report_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Mobilitas Tinggi",
          body: "Akses laporan perusahaanmu dari manapun!",
          image: Image.asset(GLOBAL.imageOnBoarding1),
        ),
        PageViewModel(
          title: "Analisa Akurat",
          body:
              "grafik, ringkasan, dan peralatan lengkap layaknya profesional!",
          image: Image.asset(GLOBAL.imageOnBoarding2),
        ),
      ],
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Text("Next"),
      done: const Text("Done"),
      onDone: () {
        // Navigate to IndexScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ReportScreen()),
        );
      },
    );
  }
}
