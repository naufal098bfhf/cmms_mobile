class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String token;
  final String? department;
  final String? photo;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    this.department,
    this.photo,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: _normalizeRole(json['role'] ?? ''),
      token: json['token'] ?? '',
      department: json['department'],
      photo: json['photo'],
      isActive: json['is_active'] ?? false,
    );
  }

  static String _normalizeRole(String role) {
    return role
        .toLowerCase()
        .trim()
        .replaceAll('_', '-')
        .replaceAll(' ', '-');
  }
}