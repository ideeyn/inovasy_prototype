import 'dart:convert';

import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/models/product_model/product_model.dart';
import 'package:inovasy_prototype/models/sales_model/sales_model.dart';
import 'package:inovasy_prototype/models/transaction_model/transaction_model.dart';
import 'package:inovasy_prototype/models/user_model/user_model.dart';
import 'package:inovasy_prototype/models/version/version.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibrarySharedPref {
  LibrarySharedPref._internal();

  static late final SharedPreferences _pref;
  static bool _isInitialized = false;
  static Future<void> init() async {
    if (_isInitialized) return; // prevent duplicate initialization error
    _pref = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  /// this singleton accessor let you to access all non static methods using
  /// static way, calling LibrarySharedpref.ref.getblabla...
  /// there only few statics; init, deprecated, logout, ref.
  static LibrarySharedPref get ref => LibrarySharedPref._internal();

//!============================ APP INTRODUCTION ==============================

  /// check if app still using same version as last app opened. if false directly
  /// return (false), if true then return (is_app_introduced ?? false).
  bool get getIsAppIntroduced {
    return _pref.getString('last_introduction') == GLOBAL.CURRENT_VERSION
        ? _pref.getBool('is_app_introduced') ?? false
        : false;
  } // this should be false for first time opening app, or first time after an update

  void setAppIntroductionDone() {
    if (getIsAppIntroduced) return; // mean its done before. no need update
    _pref.setBool('is_app_introduced', true);
    _pref.setString('last_introduction', GLOBAL.CURRENT_VERSION);
  } // so if app updated, we can set is_app_introduced back to false

//!===========================================================================||
//!                      VERSION, LOGIN, AND SYNC DATA                        ||
//!===========================================================================||
//!=============================== VERSION ====================================

  int get getAppCode => _pref.getInt('app_code') ?? 0;
  String get getAppName => _pref.getString('app_name') ?? '';
  String get getDeprVersion => _pref.getString('deprecated_version') ?? '';
  String get getMinVersion => _pref.getString('minimum_version') ?? '';
  String get getNewVersion => _pref.getString('newest_version') ?? '';
  String get getDownloadLink => _pref.getString('download_link') ?? '';
  int get getUpdateCountdown => _pref.getInt('update_countdown') ?? 0;
  String get getAppMessage => _pref.getString('app_message') ?? '';
  DateTime get getLastAssetUpdate =>
      DateTime.tryParse(_pref.getString('last_asset_update') ?? '') ??
      DateTime(0);
  void setVersion(VersionModel data) {
    _pref.setInt('app_code', data.appCode!);
    _pref.setString('app_name', data.appName!);
    _pref.setString('deprecated_version', data.deprecatedVersion!);
    _pref.setString('minimum_version', data.minimumVersion!);
    _pref.setString('newest_version', data.newestVersion!);
    _pref.setString('download_link', data.downloadLink!);
    _pref.setInt('update_countdown', data.updateCountdown!);
    _pref.setString('app_message', data.message!);
    _pref.setString('last_asset_update', data.lastAssetUpdate!);
  }

  bool get getIsDeprecated => _pref.getBool('is_deprecated') ?? true;
  void setIsDeprecated(bool isx) => _pref.setBool('is_deprecated', isx);

  bool get getIsNeedUpdate => _pref.getBool('is_need_update') ?? false;
  void setIsNeedUpdate(bool isx) => _pref.setBool('is_need_update', isx);

  bool get getIsAssetOutdated => _pref.getBool('is_asset_outdated') ?? false;
  void setIsAssetOutdated(bool isx) => _pref.setBool('is_asset_outdated', isx);

  DateTime get getValidityLimit =>
      DateTime.tryParse(_pref.getString('validity_limit') ?? '') ?? DateTime(0);
  void setValidityLimit(DateTime until) =>
      _pref.setString('validity_limit', until.toIso8601String());

  /// delete entire data. because some models might not supported anymore, mean
  /// local cache or appdata might crash with new updated app.
  static void deprecated() {
    String downloadLink = _pref.getString('download_link') ?? '';
    _pref.clear();
    _pref.setString('download_link', downloadLink);
    _pref.setBool('is_deprecated', true);
  }

//!================================ LAST SYNC =================================

  // DateTime get getlastMasterdataSync =>
  //     DateTime.tryParse(_pref.getString('last_masterdata_sync') ?? '') ??
  //     DateTime(0);
  // void setLastMasterdataSync() {
  //   _pref.setString('last_masterdata_sync', DateTime.now().toIso8601String());
  // }

  // DateTime get getlastHistorySync =>
  //     DateTime.tryParse(_pref.getString('last_history_sync') ?? '') ??
  //     DateTime(0);
  // void setLastHistorySync() {
  //   _pref.setString('last_history_sync', DateTime.now().toIso8601String());
  // }

  // DateTime get getlastInputSync =>
  //     DateTime.tryParse(_pref.getString('last_input_sync') ?? '') ??
  //     DateTime(0);
  // void setLastInputSync() {
  //   _pref.setString('last_input_sync', DateTime.now().toIso8601String());
  // }

//!===========================================================================||
//!                              MASTER DATA                                  ||
//!===========================================================================||
//!================================ VIEWER =====================================

  List<String> get getMasterViewer =>
      (jsonDecode(_pref.getString('masterdata_viewer') ?? '') as List<dynamic>)
          .map((v) => v as String)
          .toList();
  void setMasterViewer(List<String> allData) =>
      _pref.setString('masterdata_viewer', jsonEncode(allData));

//!================================ USER =====================================

  List<UserModel> get getMasterUser =>
      (jsonDecode(_pref.getString('masterdata_user') ?? '') as List<dynamic>)
          .map((json) => UserModel.fromJson(json))
          .toList();
  void setMasterUser(List<UserModel> allData) => _pref.setString(
      'masterdata_user', jsonEncode(allData.map((d) => d.toJson()).toList()));

//!================================ SALES =====================================

  List<SalesModel> get getMasterSales =>
      (jsonDecode(_pref.getString('masterdata_sales') ?? '') as List<dynamic>)
          .map((json) => SalesModel.fromJson(json))
          .toList();
  void setMasterSales(List<SalesModel> allData) => _pref.setString(
      'masterdata_sales', jsonEncode(allData.map((d) => d.toJson()).toList()));

//!=============================== PRODUCT ====================================

  List<ProductModel> get getMasterProduct =>
      (jsonDecode(_pref.getString('masterdata_product') ?? '') as List<dynamic>)
          .map((json) => ProductModel.fromJson(json))
          .toList();
  void setMasterProduct(List<ProductModel> allData) => _pref.setString(
      'masterdata_product',
      jsonEncode(allData.map((d) => d.toJson()).toList()));

//!=============================== TRANSACTION ====================================

  List<TransactionModel> get getMasterTransaction =>
      (jsonDecode(_pref.getString('masterdata_transaction') ?? '')
              as List<dynamic>)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
  void setMasterTransaction(List<TransactionModel> allData) => _pref.setString(
      'masterdata_transaction',
      jsonEncode(allData.map((d) => d.toJson()).toList()));
}
