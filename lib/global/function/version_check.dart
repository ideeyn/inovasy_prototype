import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/firebase/firebase.dart';
import 'package:inovasy_prototype/libraries/sharedpref_singleton.dart';
import 'package:inovasy_prototype/models/version/version.dart';

class VersionCheck {
  VersionCheck._();

  static int _getBuildNumber(String version) =>
      version.contains('+') ? int.tryParse(version.split('+')[1]) ?? 0 : 0;

  /// returns true if version still allowed. and false if version deprecated OR
  /// update_countdown ends. when it's false, make sure to deprecate library_sharedpref
  /// and break all background operations.
  static Future<bool> tryCallServer() async {
    // ignore: non_constant_identifier_names
    int CURRENT_BUILD = _getBuildNumber(GLOBAL.CURRENT_VERSION);
    late int minimumBuild;
    late int deprecatedBuild;
    DateTime updateLimit = LibrarySharedPref.ref.getValidityLimit;

    // trying to use server, but if failed use local instead on catch.
    try {
      VersionModel server = await LibraryFirebase.getVersion();
      LibrarySharedPref.ref.setVersion(server);
      minimumBuild = _getBuildNumber(server.minimumVersion!);
      deprecatedBuild = _getBuildNumber(server.deprecatedVersion!);
      updateLimit = updateLimit.add(Duration(days: server.updateCountdown!));
    } catch (_) {
      minimumBuild = _getBuildNumber(LibrarySharedPref.ref.getMinVersion);
      deprecatedBuild = _getBuildNumber(LibrarySharedPref.ref.getDeprVersion);
      updateLimit = updateLimit
          .add(Duration(days: LibrarySharedPref.ref.getUpdateCountdown));
      if (minimumBuild == 0) return false; // means sharedpref cleared by user
    }

    //########################################################################
    bool isDeprecated = CURRENT_BUILD <= deprecatedBuild;
    bool isNeedUpdate = CURRENT_BUILD < minimumBuild;
    bool isToldBefore = LibrarySharedPref.ref.getIsNeedUpdate;
    bool isCountEnd = DateTime.now().isAfter(updateLimit);
    //########################################################################

    if (isDeprecated || (isNeedUpdate && isToldBefore && isCountEnd)) {
      LibrarySharedPref.deprecated();
      return false; //! directing splash to update screem.
    } // when deprecated. or when update countdown end and user still dont update

    if (isNeedUpdate && isToldBefore) return true; // if it was marked before
    // then no action needed, until user [update it] or [countdown ends => deprecated]

    // just update limit and return true. but if the app is need update, then this
    // will mark "need_update" for the first time. then go to [prev if-check block]
    LibrarySharedPref.ref.setIsNeedUpdate(isNeedUpdate);
    LibrarySharedPref.ref.setValidityLimit(DateTime.now());
    return true;
  }
}
