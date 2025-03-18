import 'package:flutter/material.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/global/style/buttonstyle.dart';

class RetrySplash extends StatefulWidget {
  const RetrySplash({super.key, required this.onRetry, required this.message});

  final Function() onRetry;
  final String message;

  @override
  State<RetrySplash> createState() => _RetrySplashState();
}

class _RetrySplashState extends State<RetrySplash> {
  bool isInitDone = false;
  int initDuration = 500;
  bool isInitCircleDone = false;
  int fadeAnimation = -1;
  String message = '';
  bool isPressed = false;

  initPage() async {
    await Future.delayed(const Duration(milliseconds: 0));
    isInitDone = true;
    setState(() {});
    await Future.delayed(Duration(milliseconds: initDuration));
    isInitCircleDone = true;
    fadeAnimation++;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 100));
    fadeAnimation++;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 100));
    fadeAnimation++;
    setState(() {});

    List<String> listMessages = widget.message.split('\n');
    for (var word in listMessages) {
      await Future.delayed(const Duration(milliseconds: 100));
      message = message.isEmpty ? word : '$message\n$word';
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: isInitDone ? 200 : initDuration),
        width: MediaQuery.of(context).size.width * (isPressed ? 0.9 : 0.6),
        height: MediaQuery.of(context).size.width * (isPressed ? 0.9 : 0.6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200),
            border: Border.all(color: Colors.black, width: isPressed ? 0 : 0.5),
            color: (isInitDone && !isInitCircleDone) ? Colors.black : null),
        child: !isInitCircleDone
            ? null
            : ElevatedButton(
                onPressed: () async {
                  if (isPressed) return;
                  isPressed = true;
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 500));
                  widget.onRetry();
                },
                style: IdeeynButtonStyle.custom(
                    borderRadius: 200,
                    rippleColor: GLOBAL.appLogoColor,
                    border: BorderSide.none,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.02)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: fadeAnimation < 2 ? 0 : 145,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isPressed ? Colors.black : null),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: fadeAnimation < 0 ? 0 : 30,
                      child: fadeAnimation < 1
                          ? null
                          : Text(
                              'ada masalah jaringan. ulangi',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isPressed ? Colors.black : null),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
