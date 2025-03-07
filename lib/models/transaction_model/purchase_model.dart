class PurchaseModel {
  String? id;
  int? quantity;

  PurchaseModel({this.id, this.quantity});

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        id: json['id'] as String?,
        quantity: json['quantity'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
      };
}
