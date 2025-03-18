import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/libraries/sharedpref_singleton.dart';
import 'package:inovasy_prototype/models/product_model/product_model.dart';
import 'package:inovasy_prototype/models/sales_model/sales_model.dart';
import 'package:inovasy_prototype/models/transaction_model/transaction_model.dart';
import 'package:inovasy_prototype/models/user_model/user_model.dart';
import 'package:inovasy_prototype/models/version/version.dart';

class LibraryFirebase {
  LibraryFirebase._();
//!===========================================================================||
//!                           API TO SHAREDPREF                               ||
//!===========================================================================||

  static void firebaseToSharedpref() async {
    List<String> viewer = await getViewers();
    List<SalesModel> sales = await getSales();
    List<UserModel> user = await getUsers();
    List<ProductModel> product = await getProducts();
    List<TransactionModel> transaction = await getTransactions();

    LibrarySharedPref.ref.setMasterViewer(viewer);
    LibrarySharedPref.ref.setMasterSales(sales);
    LibrarySharedPref.ref.setMasterUser(user);
    LibrarySharedPref.ref.setMasterProduct(product);
    LibrarySharedPref.ref.setMasterTransaction(transaction);
  }

  //!############################ VERSION #####################################
  static Future<VersionModel> getVersion() async {
    var document = await FirebaseFirestore.instance
        .collection(GLOBAL.authCollection)
        .doc(GLOBAL.versionDoc)
        .get();
    dynamic field = jsonDecode(document.data()?[GLOBAL.authField]);
    return VersionModel.fromJson(field);
  }

  //!############################## SALES ######################################
  static Future<List<SalesModel>> getSales() async {
    var document = await FirebaseFirestore.instance
        .collection(GLOBAL.accountCollection)
        .doc(GLOBAL.salesDoc)
        .get();
    List<dynamic> field = jsonDecode(document.data()?[GLOBAL.accountField]);
    return field.map((user) => SalesModel.fromJson(user)).toList();
  }

  //!############################## USER ######################################
  static Future<List<UserModel>> getUsers() async {
    var document = await FirebaseFirestore.instance
        .collection(GLOBAL.accountCollection)
        .doc(GLOBAL.userDoc)
        .get();
    List<dynamic> field = jsonDecode(document.data()?[GLOBAL.accountField]);
    return field.map((user) => UserModel.fromJson(user)).toList();
  }

  //!############################## VIEWERS ###################################
  static Future<List<String>> getViewers() async {
    var document = await FirebaseFirestore.instance
        .collection(GLOBAL.shopCollection)
        .doc(GLOBAL.viewerDoc)
        .get();
    List<dynamic> field = jsonDecode(document.data()?[GLOBAL.shopField]);
    return field.map((text) => text as String).toList();
  }

  //!############################## PRODUCT ###################################
  static Future<List<ProductModel>> getProducts() async {
    var document = await FirebaseFirestore.instance
        .collection(GLOBAL.shopCollection)
        .doc(GLOBAL.productDoc)
        .get();
    List<dynamic> field = jsonDecode(document.data()?[GLOBAL.shopField]);
    return field.map((product) => ProductModel.fromJson(product)).toList();
  }

  //!############################ TRANSACTIONS ################################
  static Future<List<TransactionModel>> getTransactions() async {
    var document = await FirebaseFirestore.instance
        .collection(GLOBAL.shopCollection)
        .doc(GLOBAL.transactionDoc)
        .get();
    List<dynamic> field = jsonDecode(document.data()?[GLOBAL.shopField]);
    return field.map((transx) => TransactionModel.fromJson(transx)).toList();
  }
}
