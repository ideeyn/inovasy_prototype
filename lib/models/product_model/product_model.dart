class ProductModel {
  String? id;
  String? name;
  int? price;
  int? cost;
  int? stock;
  String? lastUpdate;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.cost,
    this.stock,
    this.lastUpdate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
        price: json['price'] as int?,
        cost: json['cost'] as int?,
        stock: json['stock'] as int?,
        lastUpdate: json['lastUpdate'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'cost': cost,
        'stock': stock,
        'lastUpdate': lastUpdate,
      };
}
