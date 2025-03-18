import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/global/style/buttonstyle.dart';
import 'package:inovasy_prototype/libraries/sharedpref_singleton.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({super.key});

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  int fadeAnimation = 0;
  String finalMessage =
      'this app version is outdated. please update first before using app.';
  String message = '';
  // Create a global key for the navigator to show SnackBars
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  runAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    fadeAnimation++;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 100));
    fadeAnimation++;
    setState(() {});

    List<String> listMessages = finalMessage.split('');
    for (var word in listMessages) {
      await Future.delayed(const Duration(milliseconds: 50));
      message = message + word;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    runAnimation();
  }

  update() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    String downloadLink = LibrarySharedPref.ref.getDownloadLink;
    if (downloadLink.isEmpty) return;

    final Uri url = Uri.parse(LibrarySharedPref.ref.getDownloadLink);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('ada masalah koneksi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = (fadeAnimation == 0) ? 5 : 2;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: GLOBAL.appLogoColor,
                  ),
                  child: Image.asset(GLOBAL.imageAppLogo),
                ),
              ),
            ),
            AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: fadeAnimation > 0 ? 40 : 0),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: fadeAnimation > 1 ? 1 : 0,
              child: Row(children: [
                // Expanded(child: IdeeynButton(onPress: update, text: 'Update'))
                Expanded(
                    child: ElevatedButton(
                  onPressed: update,
                  style: IdeeynButtonStyle.custom(
                      backgroundColor: GLOBAL.appLogoColor),
                  child: const Text('Update'),
                ))
              ]),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              child: message.isEmpty
                  ? null
                  : Text(
                      (message == finalMessage) ? message : '$message|',
                      style: const TextStyle(color: Colors.grey),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
