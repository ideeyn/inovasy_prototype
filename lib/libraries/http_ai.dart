// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/libraries/AI_APIKEY.dart';

Future<String> callAIsAPI() async {
  // String sales = ' sales datas = ' +
  //     (await FirebaseFirestore.instance
  //             .collection(GLOBAL.accountCollection)
  //             .doc(GLOBAL.salesDoc)
  //             .get())
  //         .data()?[GLOBAL.accountField];
  // String users = ' users datas = ' +
  //     (await FirebaseFirestore.instance
  //             .collection(GLOBAL.accountCollection)
  //             .doc(GLOBAL.userDoc)
  //             .get())
  //         .data()?[GLOBAL.accountField];
  // String viewers = ' viewers datas = ' +
  //     (await FirebaseFirestore.instance
  //             .collection(GLOBAL.shopCollection)
  //             .doc(GLOBAL.viewerDoc)
  //             .get())
  //         .data()?[GLOBAL.shopField];
  String products = ' products datas = ' +
      (await FirebaseFirestore.instance
              .collection(GLOBAL.shopCollection)
              .doc(GLOBAL.productDoc)
              .get())
          .data()?[GLOBAL.shopField];
  String transactions = ' transactions datas = ' +
      (await FirebaseFirestore.instance
              .collection(GLOBAL.shopCollection)
              .doc(GLOBAL.transactionDoc)
              .get())
          .data()?[GLOBAL.shopField];

  //!==========================================================================

  final response = await http.post(
    Uri.parse('https://api.mistral.ai/v1/chat/completions'),
    headers: {
      'Authorization': AI_SECRET_APIKEY,
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "model": "mistral-tiny",
      "messages": [
        {
          "role": "system",
          "content": "You are an expert in analyzing sales data."
        },
        {
          "role": "user",
          "content":
              "Analyze the following Firebase shop transactions and summarize insights in 8 short-bullets using Indonesian Language: $products and $transactions . keep the summary as short as possible while making it useful for shop owner (not useles information like 'the highest product price' since likely shop owner already know it), and start the answer with formal 'menurut data transaksi server,' like that"
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    return result['choices'][0]['message']['content'];
  } else {
    return 'Failed with message: ${response.body}';
  }
}
