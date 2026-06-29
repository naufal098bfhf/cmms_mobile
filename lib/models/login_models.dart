class LoginResponse {
  final bool status;
  final String message;
  final String token;
  final User? user;
  

  LoginResponse({
    required this.status,
    required this.message,
    required this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String token;
  final String role;
  final String? photo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.role,
    this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      role: _normalizeRole(json['role'] ?? ''),
      photo: json['photo'],
    );
  }

  static String _normalizeRole(String role) {
    return role
        .toLowerCase()
        .trim()
        .replaceAll(' ', '-')
        .replaceAll('_', '-');
  }
}