class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final String? avatarUrl;

  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          createdAt == other.createdAt &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      createdAt.hashCode ^
      avatarUrl.hashCode;
}
