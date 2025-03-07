import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/models/product_model/product_model.dart';
import 'package:inovasy_prototype/models/transaction_model/transaction_model.dart';
import 'package:inovasy_prototype/models/user_model/user_model.dart';

class LibraryFirebase {
  LibraryFirebase._();

  //!############################## USER ######################################
  static Future<List<UserModel>> getUsers() async {
    var document = await FirebaseFirestore.instance
        .collection(GLOBAL.userCollection)
        .doc(GLOBAL.userDoc)
        .get();
    List<dynamic> field = jsonDecode(document.data()?[GLOBAL.userField]);
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
  static Future<List<ProductModel>> getProduct() async {
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
