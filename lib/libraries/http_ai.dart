// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inovasy_prototype/libraries/AI_APIKEY.dart';
import 'package:inovasy_prototype/libraries/sharedpref_singleton.dart';

Future<String> callAIsAPI() async {
  String products = 'product datas = ' +
      jsonEncode(LibrarySharedPref.ref.getMasterProduct
          .map((p) => p.toJson())
          .toList());
  String transactions = 'transaction datas = ' +
      jsonEncode(LibrarySharedPref.ref.getMasterTransaction
          .map((p) => p.toJson())
          .toList());

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
