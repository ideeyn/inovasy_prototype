import 'purchase_model.dart';

class TransactionModel {
  String? sales;
  String? uid;
  String? city;
  List<PurchaseModel>? purchase;
  DateTime? date;

  TransactionModel({this.sales, this.uid, this.city, this.purchase, this.date});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      sales: json['sales'] as String?,
      uid: json['uid'] as String?,
      city: json['city'] as String?,
      purchase: (json['purchase'] as List<dynamic>?)
          ?.map((e) => PurchaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: DateTime.tryParse(json['date'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'sales': sales,
        'uid': uid,
        'city': city,
        'purchase': purchase?.map((e) => e.toJson()).toList(),
        'date': date?.toIso8601String(),
      };
}
