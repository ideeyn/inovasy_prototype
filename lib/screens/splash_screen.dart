import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inovasy_prototype/firebase/firebase.dart';
import 'package:inovasy_prototype/global/function/version_check.dart';
import 'package:inovasy_prototype/libraries/sharedpref_singleton.dart';
import 'package:inovasy_prototype/screens/onboarding/onboarding.dart';
import 'package:inovasy_prototype/screens/update/update_screen.dart';
import 'package:inovasy_prototype/screens/widget_spalsh/loading_splash.dart';
import 'package:inovasy_prototype/screens/widget_spalsh/retry_splash.dart';

//! IMPORTANT NOTE: because native splash started better, if you wanna add this
//! flutter splash make sure it matches the native for smoother transition.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Duration loadingDelay = const Duration(milliseconds: 300);
  String loadingMessage = '';
  String errorMessage = '';

  static String defaultErrorMessage = 'koneksi bermasalah';
  loadingError(String error) => setState(() => errorMessage = error);

  updateLoading(String loadMessage) async {
    loadingMessage = loadMessage;
    setState(() {});
    await Future.delayed(loadingDelay);
  }

  initData() async {
    errorMessage = '';
    setState(() {});

    //! INITIALIZE SHAREDPREF
    try {
      await updateLoading("menyiapkan data");
      await LibrarySharedPref.init();
      loadingDelay = LibrarySharedPref.ref.getIsAppIntroduced
          ? Duration.zero
          : loadingDelay;
    } catch (e) {
      return loadingError('data aplikasi bermasalah');
    }

    //! INITIALIZE FIREBASE
    try {
      await updateLoading("menyiapkan server");
      await Firebase.initializeApp();
    } catch (e) {
      return loadingError('koneksi ke server bermasalah');
    }

    //! CHECK APP VERSION
    await updateLoading("mengecek versi aplikasi");
    bool isVersionSave = await VersionCheck.tryCallServer();
    if (!mounted) return loadingError(defaultErrorMessage);
    if (!isVersionSave) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (c) => const UpdateAppScreen()));
    }
    // version is save, start downloading masterdata without awaiting
    LibraryFirebase.firebaseToSharedpref(); // DON'T use await for better UX.

    //! process done, going to next screen
    await updateLoading("menuju halaman utama");
    if (!mounted) return loadingError(defaultErrorMessage);
    return Navigator.push(
        context, MaterialPageRoute(builder: (c) => const OnboardingScreen()));
  }

  @override
  void initState() {
    super.initState(); // directly build the loading UI
    initData(); // no await. lazy checking, while UI shows loading
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: errorMessage.isNotEmpty
            ? RetrySplash(onRetry: initData, message: errorMessage)
            : LoadingSplash(loadingMessage: loadingMessage),
      ),
    );
  }
}
