class Budget {
  const Budget({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.month,
    required this.year,
  }) : assert(month >= 1 && month <= 12, 'Month must be between 1 and 12');

  final String id;
  final String userId;
  final String categoryId;
  final int amount;
  final int month;
  final int year;

  Budget copyWith({
    String? id,
    String? userId,
    String? categoryId,
    int? amount,
    int? month,
    int? year,
  }) {
    return Budget(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Budget &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          categoryId == other.categoryId &&
          amount == other.amount &&
          month == other.month &&
          year == other.year;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      categoryId.hashCode ^
      amount.hashCode ^
      month.hashCode ^
      year.hashCode;
}
