class UserModel {
  String? name;
  String? email;
  String? password;
  String? id;
  String? image;

  UserModel({this.name, this.email, this.password, this.id, this.image});
  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "email": this.email,
      "password": this.password,
      "id": this.id,
      "image": this.image,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        email: map["email"] ?? "",
        name: map["name"] ?? "",
        password: map["password"] ?? "",
        id: map["id"] ?? "",
        image: map["image"] ?? "");
  }

  copyWith(
      {String? name,
      String? email,
      String? password,
      String? id,
      String? image}) {
    return UserModel(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        id: id ?? this.id,
        image: image ?? this.image);
  }
}
