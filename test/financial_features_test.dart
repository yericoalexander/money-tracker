import 'package:duit_aman/core/state/app_state.dart';
import 'package:duit_aman/domain/entities/saving_goal.dart';
import 'package:duit_aman/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DuitAman Financial Features Unit Tests', () {
    late AppState state;

    setUp(() {
      state = AppState();
    });

    test('Saving Goals can be added, deposited to, and calculated correctly', () {
      final initialGoalsCount = state.savingGoals.length;
      final newGoal = SavingGoal(
        id: 'test_goal_1',
        userId: state.currentUserId,
        name: 'Investasi Emas',
        targetAmount: 10000000,
        currentAmount: 2000000,
        targetDate: DateTime.now().add(const Duration(days: 90)),
        icon: '🪙',
      );

      state.addSavingGoal(newGoal);
      expect(state.savingGoals.length, initialGoalsCount + 1);
      expect(newGoal.progressPercentage, 0.2);
      expect(newGoal.remainingAmount, 8000000);
      expect(newGoal.isAchieved, false);

      // Test Deposit
      final wallet = state.wallets.first;
      final initialWalletBalance = wallet.balance;
      state.depositToSavingGoal('test_goal_1', 1000000, wallet.id);

      final updatedGoal = state.savingGoals.firstWhere((g) => g.id == 'test_goal_1');
      expect(updatedGoal.currentAmount, 3000000);
      expect(updatedGoal.progressPercentage, 0.3);

      final updatedWallet = state.getWalletById(wallet.id);
      expect(updatedWallet.balance, initialWalletBalance - 1000000);
    });

    test('3-Type Expenses (Needs, Wants, Obligations) calculate accurately', () {
      final now = DateTime.now();

      final needs = state.totalNeedsThisMonth();
      final wants = state.totalWantsThisMonth();
      final obligations = state.totalObligationsThisMonth();

      expect(needs, greaterThan(0));
      expect(wants, greaterThan(0));
      expect(obligations, greaterThan(0));

      // Tambah transaksi kebutuhan baru
      state.addTransaction(
        Transaction(
          id: 'test_tx_needs',
          userId: state.currentUserId,
          categoryId: 'makan',
          walletId: state.wallets.first.id,
          amount: 50000,
          type: TransactionType.expense,
          date: now,
          classification: ExpenseClassification.needs,
        ),
      );

      expect(state.totalNeedsThisMonth(), needs + 50000);
    });

    test('Food Expense Tracker tracks meal types and daily average', () {
      final foodTotal = state.totalFoodExpenseThisMonth();
      expect(foodTotal, greaterThan(0));

      final breakdown = state.foodExpenseByMealType();
      expect(breakdown.containsKey(MealType.lunch), true);
      expect(breakdown.containsKey(MealType.snack), true);
      expect(breakdown.containsKey(MealType.groceries), true);

      final dailyAvg = state.averageDailyFoodExpense();
      expect(dailyAvg, greaterThan(0));
    });

    test('Financial Health Score computes within 10-100 bounds', () {
      final score = state.financialHealthScore();
      expect(score, inInclusiveRange(10, 100));

      final status = state.financialHealthStatus();
      expect(
        ['Sangat Sehat', 'Cukup Sehat', 'Waspada', 'Perlu Penghematan'].contains(status),
        true,
      );

      final insight = state.financialHealthInsight();
      expect(insight.isNotEmpty, true);
    });
  });
}
