class SalesModel {
  String? sid;
  String? name;

  SalesModel({this.sid, this.name});

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        sid: json['sid'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'sid': sid,
        'name': name,
      };
}
