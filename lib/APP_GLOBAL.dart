// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class GLOBAL {
  GLOBAL._();

//!############################### VERSION ####################################

  static String APP_NAME = 'Inovasy-Prototype';
  static String CURRENT_VERSION = '1.0.0+1'; //! <========== CHANGE EVERY UPDATE

//!################################ THEME #####################################

  static Color appLogoColor = const Color.fromARGB(255, 251, 86, 7);
  static Color appBackgroundColor = Colors.grey.shade300;

//!########################## FIREBASE VARIABLES ##############################
  static String FIREBASE_ID = "ideeyn-inovasy-prototype";
  static String accountCollection = "account";
  static String shopCollection = "shop";
  // -----------------------------------------------
  static String userDoc = "user";
  static String salesDoc = "sales";
  // -----------------------------------------------
  static String productDoc = "product";
  static String transactionDoc = "transaction";
  static String viewerDoc = "viewer";
  // -----------------------------------------------
  static String accountField = "json";
  static String shopField = "json";

//!############################## IMAGE PATHS #################################

  static String imageAppLogo = 'assets/images/inovasy_logo.png';
  static String imageAppMotto = 'assets/images/inovasy_logo.png';
  static String imageOnBoarding1 = 'assets/images/onboarding_1.jpeg'; //! jpeg
  static String imageOnBoarding2 = 'assets/images/onboarding_2.jpeg'; //! jpeg
  static String imageCart = 'assets/images/cart.png';
  static String imageCredit = 'assets/images/credit.png';
  static String imageGraphFiller = 'assets/images/filler_blue.png';
  static String imageFund = 'assets/images/fund.png';
  static String imageGraph = 'assets/images/graph.png';
  static String imageHeadDecor = 'assets/images/header_decoration.png';
  static String imageMoney = 'assets/images/money.png';
  static String imagePerson = 'assets/images/person.png';
  static String imageTrade = 'assets/images/trade.png';
}
