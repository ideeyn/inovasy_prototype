class ProductModel {
	int? id;
	String? name;
	int? price;
	int? cost;
	int? count;
	String? lastUpdate;

	ProductModel({
		this.id, 
		this.name, 
		this.price, 
		this.cost, 
		this.count, 
		this.lastUpdate, 
	});

	factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
				id: json['id'] as int?,
				name: json['name'] as String?,
				price: json['price'] as int?,
				cost: json['cost'] as int?,
				count: json['count'] as int?,
				lastUpdate: json['lastUpdate'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
				'price': price,
				'cost': cost,
				'count': count,
				'lastUpdate': lastUpdate,
			};
}
