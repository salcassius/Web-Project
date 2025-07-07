class User {
  final String fullName;
  final String email;
  final String password;

  User({
    required this.fullName,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'password': password,
      };

  // Helper method for validation
  bool isValid() {
    return fullName.isNotEmpty && 
           email.isNotEmpty && 
           email.contains('@') && 
           password.isNotEmpty;
  }

  // Copy method for updates
  User copyWith({
    String? fullName,
    String? email,
    String? password,
  }) {
    return User(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}