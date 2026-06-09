class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final List<String> musicPreferences;
  final String initials;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.musicPreferences,
  }) : initials =
  name.split(' ').take(2).map((e) => e[0]).join().toUpperCase();
}