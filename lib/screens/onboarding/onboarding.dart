import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/global/style/buttonstyle.dart';
import 'package:inovasy_prototype/screens/index/report/report_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        hasFloatingButton: false, // Keeps text lower
        controllerColor: Colors.orange, // Dots color
        totalPage: 2,
        headerBackgroundColor: Colors.white,
        background: [
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                top: MediaQuery.of(context).size.height * 0.1),
            child: Image.asset(GLOBAL.imageOnBoarding1,
                width: MediaQuery.of(context).size.width * 0.8),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                top: MediaQuery.of(context).size.height * 0.1),
            child: Image.asset(GLOBAL.imageOnBoarding2,
                width: MediaQuery.of(context).size.width * 0.8),
          ),
        ],
        speed: 1.8, // Adjust transition speed
        pageBodies: [
          _buildPage(
            context,
            title: "Mobilitas Tinggi",
            body: "Akses laporan perusahaanmu\ndari manapun!",
            isLast: false,
          ),
          _buildPage(
            context,
            title: "Analisa Akurat",
            body:
                "Grafik, ringkasan, dan peralatan\nlengkap layaknya profesional!",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context,
      {required String title, required String body, required bool isLast}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // Centers text vertically
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.52),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          body,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        if (isLast)
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const ReportScreen()));
                },
                style: IdeeynButtonStyle.custom(
                  backgroundColor: Colors.orange.shade200,
                ),
                child: const Text('Mulai'),
              )),
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            ],
          ),
      ],
    );
  }
}
