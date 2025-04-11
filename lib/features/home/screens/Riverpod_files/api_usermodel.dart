class UserModelApi {
  final String firstname;
  final String email;
  final String lastname;
  final String avatar;

  UserModelApi({
    required this.firstname,
    required this.email,
    required this.lastname,
    required this.avatar,
  });

  factory UserModelApi.fromMap(Map<String, dynamic> map) {
    return UserModelApi(
      email: map['email'],
      firstname: map['first_name'],
      lastname: map['last_name'],
      avatar: map['avatar'],
    );
  }
}
