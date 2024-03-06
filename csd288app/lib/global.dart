class UserData {
  final String username;
  final String password;
  final String email;

  UserData({required this.username, required this.password, required this.email});

  @override
  String toString() {
    return 'UserData{username: $username, password: $password, email: $email}';
  }
}

List<UserData> globalUsers = [];