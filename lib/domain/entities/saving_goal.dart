class SavingGoal {
  const SavingGoal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    this.icon = '🎯',
  });

  final String id;
  final String userId;
  final String name;
  final int targetAmount;
  final int currentAmount;
  final DateTime targetDate;
  final String icon;

  double get progressPercentage {
    if (targetAmount <= 0) return 1.0;
    final progress = currentAmount / targetAmount;
    return progress.clamp(0.0, 1.0);
  }

  int get remainingAmount =>
      (targetAmount - currentAmount) > 0 ? targetAmount - currentAmount : 0;

  bool get isAchieved => currentAmount >= targetAmount;

  SavingGoal copyWith({
    String? id,
    String? userId,
    String? name,
    int? targetAmount,
    int? currentAmount,
    DateTime? targetDate,
    String? icon,
  }) {
    return SavingGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingGoal &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          name == other.name &&
          targetAmount == other.targetAmount &&
          currentAmount == other.currentAmount &&
          targetDate == other.targetDate &&
          icon == other.icon;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      targetAmount.hashCode ^
      currentAmount.hashCode ^
      targetDate.hashCode ^
      icon.hashCode;
}
