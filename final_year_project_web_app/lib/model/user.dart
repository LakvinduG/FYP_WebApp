class User {
  final String username;
  final String email;
  final String token;
  final String role;
  final int? companyId;
  final String? companyName;
  final String? registrationNo;

  User({
    required this.username,
    required this.email,
    required this.token,
    required this.role,
    this.companyId,
    this.companyName,
    this.registrationNo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      role: json['role'] ?? '',
      companyId: json['companyId'],
      companyName: json['companyName'],
      registrationNo: json['registrationNo'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'token': token,
      'role': role,
      'companyId': companyId,
      'companyName': companyName,
      'registrationNo': registrationNo,
    };
  }
}
