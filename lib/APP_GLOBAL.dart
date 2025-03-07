// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class GLOBAL {
  GLOBAL._();

  static Color appLogoColor = const Color.fromARGB(255, 251, 86, 7);
  static Color appBackgroundColor = Colors.grey.shade300;

//!########################## FIREBASE VARIABLES ##############################
  static String FIREBASE_ID = "ideeyn-inovasy-prototype";
  static String userCollection = "user";
  static String shopCollection = "shop";
  // -----------------------------------------------
  static String userDoc = "profile";
  // -----------------------------------------------
  static String productDoc = "product";
  static String transactionDoc = "transaction";
  static String viewerDoc = "viewer";
  // -----------------------------------------------
  static String userField = "json";
  static String shopField = "json";
}
