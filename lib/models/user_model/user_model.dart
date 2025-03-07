class UserModel {
	String? uid;
	String? name;

	UserModel({this.uid, this.name});

	factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
				uid: json['uid'] as String?,
				name: json['name'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'uid': uid,
				'name': name,
			};
}
