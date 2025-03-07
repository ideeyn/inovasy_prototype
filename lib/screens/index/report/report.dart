import 'package:flutter/material.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        backgroundColor: GLOBAL.appLogoColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              )),
        ],
      ),
      backgroundColor: GLOBAL.appBackgroundColor,
      body: const Center(
        child: Text('halo'),
      ),
    );
  }
}
