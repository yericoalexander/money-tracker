import 'category.dart';

typedef TransactionType = CategoryType;

enum ExpenseClassification {
  needs, // Kebutuhan (50%)
  wants, // Keinginan (30%)
  obligations, // Kewajiban (20%)
}

extension ExpenseClassificationX on ExpenseClassification {
  String get label {
    switch (this) {
      case ExpenseClassification.needs:
        return 'Kebutuhan';
      case ExpenseClassification.wants:
        return 'Keinginan';
      case ExpenseClassification.obligations:
        return 'Kewajiban';
    }
  }

  String get percentageBadge {
    switch (this) {
      case ExpenseClassification.needs:
        return '50%';
      case ExpenseClassification.wants:
        return '30%';
      case ExpenseClassification.obligations:
        return '20%';
    }
  }
}

enum MealType {
  breakfast, // Sarapan
  lunch, // Makan Siang
  dinner, // Makan Malam
  snack, // Jajan / Kopi
  groceries, // Belanja Dapur
}

extension MealTypeX on MealType {
  String get label {
    switch (this) {
      case MealType.breakfast:
        return 'Sarapan';
      case MealType.lunch:
        return 'Makan Siang';
      case MealType.dinner:
        return 'Makan Malam';
      case MealType.snack:
        return 'Jajan / Kopi';
      case MealType.groceries:
        return 'Bahan Masak';
    }
  }

  String get icon {
    switch (this) {
      case MealType.breakfast:
        return '🍳';
      case MealType.lunch:
        return '🍲';
      case MealType.dinner:
        return '🍛';
      case MealType.snack:
        return '☕';
      case MealType.groceries:
        return '🛒';
    }
  }
}

class Transaction {
  const Transaction({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.walletId,
    required this.amount,
    required this.type,
    required this.date,
    this.note = '',
    this.classification = ExpenseClassification.needs,
    this.mealType,
  });

  final String id;
  final String userId;
  final String categoryId;
  final String walletId;
  final int amount;
  final TransactionType type;
  final DateTime date;
  final String note;
  final ExpenseClassification classification;
  final MealType? mealType;

  Transaction copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? walletId,
    int? amount,
    TransactionType? type,
    DateTime? date,
    String? note,
    ExpenseClassification? classification,
    MealType? mealType,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      walletId: walletId ?? this.walletId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      classification: classification ?? this.classification,
      mealType: mealType ?? this.mealType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          categoryId == other.categoryId &&
          walletId == other.walletId &&
          amount == other.amount &&
          type == other.type &&
          date == other.date &&
          note == other.note &&
          classification == other.classification &&
          mealType == other.mealType;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      categoryId.hashCode ^
      walletId.hashCode ^
      amount.hashCode ^
      type.hashCode ^
      date.hashCode ^
      note.hashCode ^
      classification.hashCode ^
      (mealType?.hashCode ?? 0);
}
