import 'package:flutter/material.dart';

import '../../domain/entities/budget.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/saving_goal.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/wallet.dart';
import '../constants/default_categories.dart';

class AppState extends ChangeNotifier {
  AppState() {
    _initDefaultState();
  }

  User _currentUser = User(
    id: 'user_default',
    name: 'Yerico Alexander',
    email: 'yerico@duitaman.id',
    createdAt: DateTime.now(),
  );

  final List<Category> _customCategories = [];
  final List<Transaction> _transactions = [];
  final List<Budget> _budgets = [];
  final List<Wallet> _wallets = [];
  final List<SavingGoal> _savingGoals = [];

  User get currentUser => _currentUser;
  String get currentUserId => _currentUser.id;

  List<Category> get expenseCategories => [
        ...kDefaultExpenseCategories,
        ..._customCategories.where((c) => c.type == CategoryType.expense),
      ];

  List<Category> get incomeCategories => [
        ...kDefaultIncomeCategories,
        ..._customCategories.where((c) => c.type == CategoryType.income),
      ];

  List<Category> get allCategories => [
        ...expenseCategories,
        ...incomeCategories,
      ];

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<Budget> get budgets => List.unmodifiable(_budgets);
  List<Wallet> get wallets => List.unmodifiable(_wallets);
  List<SavingGoal> get savingGoals => List.unmodifiable(_savingGoals);

  void _initDefaultState() {
    // 1. Inisialisasi Dompet
    _wallets.addAll([
      Wallet(
        id: 'wallet_main',
        userId: _currentUser.id,
        name: 'Rekening Utama (BCA)',
        type: WalletType.bank,
        balance: 14500000,
      ),
      Wallet(
        id: 'wallet_cash',
        userId: _currentUser.id,
        name: 'Dompet Tunai',
        type: WalletType.cash,
        balance: 1250000,
      ),
      Wallet(
        id: 'wallet_ewallet',
        userId: _currentUser.id,
        name: 'GoPay / OVO',
        type: WalletType.ewallet,
        balance: 850000,
      ),
    ]);

    // 2. Inisialisasi Saving Goals (Impian Tabungan)
    final now = DateTime.now();
    _savingGoals.addAll([
      SavingGoal(
        id: 'goal_1',
        userId: _currentUser.id,
        name: 'Dana Darurat 6 Bulan',
        targetAmount: 30000000,
        currentAmount: 18500000,
        targetDate: DateTime(now.year, now.month + 6, 1),
        icon: '🛡️',
      ),
      SavingGoal(
        id: 'goal_2',
        userId: _currentUser.id,
        name: 'Upgrade iPhone 17',
        targetAmount: 16000000,
        currentAmount: 12000000,
        targetDate: DateTime(now.year, now.month + 2, 15),
        icon: '📱',
      ),
      SavingGoal(
        id: 'goal_3',
        userId: _currentUser.id,
        name: 'Liburan Akhir Tahun',
        targetAmount: 8000000,
        currentAmount: 3500000,
        targetDate: DateTime(now.year, 12, 25),
        icon: '✈️',
      ),
    ]);

    // 3. Inisialisasi Transaksi Awal (Pemasukan, 3 Jenis Pengeluaran & Detail Makan)
    _transactions.addAll([
      Transaction(
        id: 'tx_inc_1',
        userId: _currentUser.id,
        categoryId: 'gaji',
        walletId: 'wallet_main',
        amount: 15000000,
        type: TransactionType.income,
        date: DateTime(now.year, now.month, 1),
        note: 'Gaji Bulanan',
      ),
      Transaction(
        id: 'tx_inc_2',
        userId: _currentUser.id,
        categoryId: 'freelance',
        walletId: 'wallet_main',
        amount: 3500000,
        type: TransactionType.income,
        date: DateTime(now.year, now.month, 5),
        note: 'Project UI/UX Mobile App',
      ),
      // Pengeluaran Kebutuhan (Needs) & Makan
      Transaction(
        id: 'tx_exp_1',
        userId: _currentUser.id,
        categoryId: 'makan',
        walletId: 'wallet_cash',
        amount: 35000,
        type: TransactionType.expense,
        date: DateTime(now.year, now.month, now.day),
        note: 'Nasi Padang Komplit',
        classification: ExpenseClassification.needs,
        mealType: MealType.lunch,
      ),
      Transaction(
        id: 'tx_exp_2',
        userId: _currentUser.id,
        categoryId: 'makan',
        walletId: 'wallet_ewallet',
        amount: 28000,
        type: TransactionType.expense,
        date: DateTime(now.year, now.month, now.day),
        note: 'Kopi Susu Gula Aren',
        classification: ExpenseClassification.wants,
        mealType: MealType.snack,
      ),
      Transaction(
        id: 'tx_exp_3',
        userId: _currentUser.id,
        categoryId: 'makan',
        walletId: 'wallet_ewallet',
        amount: 250000,
        type: TransactionType.expense,
        date: DateTime(now.year, now.month, now.day > 1 ? now.day - 1 : 1),
        note: 'Belanja Sayur & Daging Mingguan',
        classification: ExpenseClassification.needs,
        mealType: MealType.groceries,
      ),
      // Pengeluaran Kewajiban (Obligations)
      Transaction(
        id: 'tx_exp_4',
        userId: _currentUser.id,
        categoryId: 'tagihan',
        walletId: 'wallet_main',
        amount: 750000,
        type: TransactionType.expense,
        date: DateTime(now.year, now.month, 3),
        note: 'Listrik PLN & WiFi Internet',
        classification: ExpenseClassification.obligations,
      ),
      // Pengeluaran Keinginan (Wants)
      Transaction(
        id: 'tx_exp_5',
        userId: _currentUser.id,
        categoryId: 'hiburan',
        walletId: 'wallet_main',
        amount: 186000,
        type: TransactionType.expense,
        date: DateTime(now.year, now.month, 4),
        note: 'Tiket Bioskop & Popcorn',
        classification: ExpenseClassification.wants,
      ),
      Transaction(
        id: 'tx_exp_6',
        userId: _currentUser.id,
        categoryId: 'transport',
        walletId: 'wallet_ewallet',
        amount: 45000,
        type: TransactionType.expense,
        date: DateTime(now.year, now.month, now.day),
        note: 'Bensin & Tol',
        classification: ExpenseClassification.needs,
      ),
    ]);

    // 4. Inisialisasi Anggaran Bulanan
    _budgets.addAll([
      Budget(
        id: 'b_makan',
        userId: _currentUser.id,
        categoryId: 'makan',
        amount: 2500000,
        month: now.month,
        year: now.year,
      ),
      Budget(
        id: 'b_transport',
        userId: _currentUser.id,
        categoryId: 'transport',
        amount: 800000,
        month: now.month,
        year: now.year,
      ),
      Budget(
        id: 'b_hiburan',
        userId: _currentUser.id,
        categoryId: 'hiburan',
        amount: 1000000,
        month: now.month,
        year: now.year,
      ),
      Budget(
        id: 'b_tagihan',
        userId: _currentUser.id,
        categoryId: 'tagihan',
        amount: 1500000,
        month: now.month,
        year: now.year,
      ),
    ]);
  }

  void updateProfileName(String name, String email) {
    _currentUser = _currentUser.copyWith(name: name, email: email);
    notifyListeners();
  }

  void resetAllData() {
    _transactions.clear();
    _budgets.clear();
    _wallets.clear();
    _customCategories.clear();
    _savingGoals.clear();
    _initDefaultState();
    notifyListeners();
  }

  // --- Perhitungan Agregat Finansial ---

  int totalSpentThisMonth(String categoryId, {int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    return _transactions
        .where((t) =>
            t.userId == _currentUser.id &&
            t.type == TransactionType.expense &&
            t.categoryId == categoryId &&
            t.date.month == targetMonth &&
            t.date.year == targetYear)
        .fold(0, (sum, t) => sum + t.amount);
  }

  int totalExpenseThisMonth({int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    return _transactions
        .where((t) =>
            t.userId == _currentUser.id &&
            t.type == TransactionType.expense &&
            t.date.month == targetMonth &&
            t.date.year == targetYear)
        .fold(0, (sum, t) => sum + t.amount);
  }

  int totalIncomeThisMonth({int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    return _transactions
        .where((t) =>
            t.userId == _currentUser.id &&
            t.type == TransactionType.income &&
            t.date.month == targetMonth &&
            t.date.year == targetYear)
        .fold(0, (sum, t) => sum + t.amount);
  }

  int totalBudgetThisMonth({int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    return _budgets
        .where((b) =>
            b.userId == _currentUser.id &&
            b.month == targetMonth &&
            b.year == targetYear)
        .fold(0, (sum, b) => sum + b.amount);
  }

  int totalWalletBalance() {
    return _wallets.fold(0, (sum, w) => sum + w.balance);
  }

  // --- 3 Jenis Pengeluaran (Needs, Wants, Obligations) ---

  int totalNeedsThisMonth({int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.classification == ExpenseClassification.needs &&
            t.date.month == targetMonth &&
            t.date.year == targetYear)
        .fold(0, (sum, t) => sum + t.amount);
  }

  int totalWantsThisMonth({int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.classification == ExpenseClassification.wants &&
            t.date.month == targetMonth &&
            t.date.year == targetYear)
        .fold(0, (sum, t) => sum + t.amount);
  }

  int totalObligationsThisMonth({int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.classification == ExpenseClassification.obligations &&
            t.date.month == targetMonth &&
            t.date.year == targetYear)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // --- Food Expense Tracker Aggregations ---

  int totalFoodExpenseThisMonth({int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            (t.categoryId == 'makan' || t.categoryId == 'makanan') &&
            t.date.month == targetMonth &&
            t.date.year == targetYear)
        .fold(0, (sum, t) => sum + t.amount);
  }

  Map<MealType, int> foodExpenseByMealType({int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    final result = <MealType, int>{
      MealType.breakfast: 0,
      MealType.lunch: 0,
      MealType.dinner: 0,
      MealType.snack: 0,
      MealType.groceries: 0,
    };

    final foodTxns = _transactions.where((t) =>
        t.type == TransactionType.expense &&
        (t.categoryId == 'makan' || t.categoryId == 'makanan') &&
        t.date.month == targetMonth &&
        t.date.year == targetYear);

    for (final t in foodTxns) {
      final mt = t.mealType ?? MealType.lunch;
      result[mt] = (result[mt] ?? 0) + t.amount;
    }

    return result;
  }

  int averageDailyFoodExpense() {
    final now = DateTime.now();
    final daysPassed = now.day > 0 ? now.day : 1;
    final totalFood = totalFoodExpenseThisMonth();
    return (totalFood / daysPassed).round();
  }

  // --- Saving Goals Management ---

  int totalSavingsAmount() {
    return _savingGoals.fold(0, (sum, g) => sum + g.currentAmount);
  }

  int totalSavingsTarget() {
    return _savingGoals.fold(0, (sum, g) => sum + g.targetAmount);
  }

  void addSavingGoal(SavingGoal goal) {
    _savingGoals.add(goal);
    notifyListeners();
  }

  void depositToSavingGoal(String goalId, int amount, String walletId) {
    final gIndex = _savingGoals.indexWhere((g) => g.id == goalId);
    final wIndex = _wallets.indexWhere((w) => w.id == walletId);

    if (gIndex != -1 && wIndex != -1) {
      final goal = _savingGoals[gIndex];
      final wallet = _wallets[wIndex];

      // Kurangi saldo dompet
      _wallets[wIndex] = wallet.copyWith(balance: wallet.balance - amount);
      // Tambah saldo impian tabungan
      _savingGoals[gIndex] = goal.copyWith(
        currentAmount: goal.currentAmount + amount,
      );

      // Catat sebagai transaksi tabungan
      _transactions.insert(
        0,
        Transaction(
          id: 'tx_save_${DateTime.now().millisecondsSinceEpoch}',
          userId: _currentUser.id,
          categoryId: 'tabungan',
          walletId: walletId,
          amount: amount,
          type: TransactionType.expense,
          date: DateTime.now(),
          note: 'Setor Tabungan: ${goal.name}',
          classification: ExpenseClassification.obligations,
        ),
      );

      notifyListeners();
    }
  }

  void deleteSavingGoal(String goalId) {
    _savingGoals.removeWhere((g) => g.id == goalId);
    notifyListeners();
  }

  // --- Evaluasi Financial Health Score ---

  int financialHealthScore() {
    final income = totalIncomeThisMonth();
    final expense = totalExpenseThisMonth();

    if (income <= 0) return 50; // Belum ada data pendapatan

    double score = 100.0;

    // 1. Rasio Pengeluaran terhadap Pendapatan (ideal <= 70%)
    final expenseRatio = expense / income;
    if (expenseRatio > 1.0) {
      score -= 40; // Defisit pengeluaran > pemasukan
    } else if (expenseRatio > 0.8) {
      score -= 25;
    } else if (expenseRatio > 0.7) {
      score -= 10;
    }

    // 2. Rasio Menabung (ideal >= 20%)
    final savings = totalSavingsAmount();
    if (savings > 0) {
      score += 5;
    }

    // 3. Cek pengeluaran Wants (ideal <= 30% dari total pengeluaran)
    if (expense > 0) {
      final wants = totalWantsThisMonth();
      final wantsRatio = wants / expense;
      if (wantsRatio > 0.45) {
        score -= 15;
      }
    }

    return score.round().clamp(10, 100);
  }

  String financialHealthStatus() {
    final score = financialHealthScore();
    if (score >= 80) return 'Sangat Sehat';
    if (score >= 65) return 'Cukup Sehat';
    if (score >= 50) return 'Waspada';
    return 'Perlu Penghematan';
  }

  String financialHealthInsight() {
    final income = totalIncomeThisMonth();
    final expense = totalExpenseThisMonth();
    final wants = totalWantsThisMonth();

    if (income <= 0) {
      return 'Catat pendapatan bulanan Anda agar evaluasi kesehatan finansial dapat dihitung secara akurat.';
    }

    if (expense > income) {
      return 'Pengeluaran bulan ini melebihi pemasukan. Kurangi pos Keinginan (Wants) untuk menyeimbangkan arus kas.';
    }

    if (expense > 0 && (wants / expense) > 0.35) {
      return 'Porsi Keinginan (Wants) Anda mencapai ${((wants / expense) * 100).toStringAsFixed(0)}%. Idealnya maksimal 30% dari total pengeluaran.';
    }

    return 'Arus kas keuangan Anda bulan ini sangat prima! Pertahankan alokasi menabung secara disiplin.';
  }

  Category getCategoryById(String id) {
    return allCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => Category(
        id: id,
        name: id,
        iconAsset: 'assets/icons/lainnya.svg',
      ),
    );
  }

  Wallet getWalletById(String id) {
    return _wallets.firstWhere(
      (w) => w.id == id,
      orElse: () => _wallets.isNotEmpty
          ? _wallets.first
          : Wallet(
              id: 'default',
              userId: _currentUser.id,
              name: 'Dompet Utama',
              type: WalletType.cash,
              balance: 0,
            ),
    );
  }

  Budget? getBudgetForCategory(String categoryId, {int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    try {
      return _budgets.firstWhere(
        (b) =>
            b.userId == _currentUser.id &&
            b.categoryId == categoryId &&
            b.month == targetMonth &&
            b.year == targetYear,
      );
    } catch (_) {
      return null;
    }
  }

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);

    final wIndex = _wallets.indexWhere((w) => w.id == transaction.walletId);
    if (wIndex != -1) {
      final w = _wallets[wIndex];
      final newBalance = transaction.type == TransactionType.income
          ? w.balance + transaction.amount
          : w.balance - transaction.amount;
      _wallets[wIndex] = w.copyWith(balance: newBalance);
    }

    notifyListeners();
  }

  void deleteTransaction(String transactionId) {
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      final txn = _transactions[index];
      final wIndex = _wallets.indexWhere((w) => w.id == txn.walletId);
      if (wIndex != -1) {
        final w = _wallets[wIndex];
        final newBalance = txn.type == TransactionType.income
            ? w.balance - txn.amount
            : w.balance + txn.amount;
        _wallets[wIndex] = w.copyWith(balance: newBalance);
      }
      _transactions.removeAt(index);
      notifyListeners();
    }
  }

  void setOrUpdateBudget(String categoryId, int amount, {int? month, int? year}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    final index = _budgets.indexWhere(
      (b) =>
          b.userId == _currentUser.id &&
          b.categoryId == categoryId &&
          b.month == targetMonth &&
          b.year == targetYear,
    );

    if (index != -1) {
      _budgets[index] = _budgets[index].copyWith(amount: amount);
    } else {
      _budgets.add(
        Budget(
          id: 'budget_${categoryId}_${targetMonth}_$targetYear',
          userId: _currentUser.id,
          categoryId: categoryId,
          amount: amount,
          month: targetMonth,
          year: targetYear,
        ),
      );
    }
    notifyListeners();
  }

  void addWallet(String name, WalletType type, int initialBalance) {
    final newWallet = Wallet(
      id: 'wallet_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser.id,
      name: name,
      type: type,
      balance: initialBalance,
    );
    _wallets.add(newWallet);
    notifyListeners();
  }
}
