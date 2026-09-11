import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/rupiah.dart';
import '../widgets/category_icon_widget.dart';
import '../widgets/transaction_tile.dart';
import 'category_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.state,
    this.onViewAllTransactions,
    this.onOpenSavings,
    this.onOpenOverview,
  });

  final AppState state;
  final VoidCallback? onViewAllTransactions;
  final VoidCallback? onOpenSavings;
  final VoidCallback? onOpenOverview;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final totalExpense = state.totalExpenseThisMonth();
    final totalIncome = state.totalIncomeThisMonth();
    final netBalance = state.totalWalletBalance();
    final healthScore = state.financialHealthScore();
    final healthStatus = state.financialHealthStatus();

    // 3 Types
    final needs = state.totalNeedsThisMonth();
    final wants = state.totalWantsThisMonth();
    final obligations = state.totalObligationsThisMonth();
    final totalClassified = needs + wants + obligations;

    // Savings
    final goals = state.savingGoals;
    final totalSavings = state.totalSavingsAmount();

    // Food
    final totalFood = state.totalFoodExpenseThisMonth();
    final dailyFood = state.averageDailyFoodExpense();

    final categories = state.expenseCategories;
    final overBudgetCategories = categories.where((c) {
      final b = state.getBudgetForCategory(c.id);
      final spent = state.totalSpentThisMonth(c.id);
      return b != null && b.amount > 0 && spent > b.amount;
    }).toList();

    return Scaffold(
      backgroundColor: AppPalette.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppPalette.primary,
          backgroundColor: AppPalette.pureWhite,
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              // 1. Header Profil Pengguna & Judul Dashboard
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${state.currentUser.name}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'DuitAman',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppPalette.primaryDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppPalette.iceBlue,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppPalette.line),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            size: 14, color: AppPalette.primary),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now()),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. KARTU UTAMA: SALDO & FINANCIAL HEALTH BADGE (Blue Gradient & White)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppPalette.primaryDark, AppPalette.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.primary.withOpacity(0.28),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Saldo Dompet',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppPalette.iceBlueLight.withOpacity(0.85),
                          ),
                        ),
                        // Financial Health Badge (Clickable)
                        GestureDetector(
                          onTap: widget.onOpenOverview,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_rounded,
                                    size: 14, color: AppPalette.sky),
                                const SizedBox(width: 4),
                                Text(
                                  '$healthScore/100 · $healthStatus',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppPalette.pureWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${Rupiah.format(netBalance)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppPalette.pureWhite,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Baris Pemasukan vs Pengeluaran Bulan Ini
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_downward_rounded,
                                    size: 14,
                                    color: AppPalette.sky,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pemasukan',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppPalette.iceBlueLight
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    Text(
                                      'Rp ${Rupiah.format(totalIncome)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppPalette.pureWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 28,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    size: 14,
                                    color: Color(0xFFFCA5A5),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pengeluaran',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppPalette.iceBlueLight
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    Text(
                                      'Rp ${Rupiah.format(totalExpense)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppPalette.pureWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. FITUR 3 JENIS PENGELUARAN (50/30/20 Rule Quick Bar)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPalette.pureWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppPalette.line),
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.primaryDark.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pola Pengeluaran (50/30/20)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.ink,
                          ),
                        ),
                        if (widget.onOpenOverview != null)
                          GestureDetector(
                            onTap: widget.onOpenOverview,
                            child: Text(
                              'Lihat Detail →',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Multi-segmented Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 8,
                        child: Row(
                          children: [
                            if (totalClassified > 0 && needs > 0)
                              Expanded(
                                flex: needs,
                                child: Container(color: AppPalette.needs),
                              ),
                            if (totalClassified > 0 && wants > 0)
                              Expanded(
                                flex: wants,
                                child: Container(color: AppPalette.wants),
                              ),
                            if (totalClassified > 0 && obligations > 0)
                              Expanded(
                                flex: obligations,
                                child: Container(color: AppPalette.obligations),
                              ),
                            if (totalClassified == 0)
                              Expanded(
                                child: Container(color: AppPalette.iceBlue),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _LegendDot(
                          label: 'Kebutuhan',
                          pct: totalClassified > 0
                              ? '${((needs / totalClassified) * 100).toStringAsFixed(0)}%'
                              : '0%',
                          color: AppPalette.needs,
                        ),
                        _LegendDot(
                          label: 'Keinginan',
                          pct: totalClassified > 0
                              ? '${((wants / totalClassified) * 100).toStringAsFixed(0)}%'
                              : '0%',
                          color: AppPalette.wants,
                        ),
                        _LegendDot(
                          label: 'Kewajiban',
                          pct: totalClassified > 0
                              ? '${((obligations / totalClassified) * 100).toStringAsFixed(0)}%'
                              : '0%',
                          color: AppPalette.obligations,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. BARIS DUA KARTU: SAVING TRACKER & FOOD TRACKER PREVIEWS
              Row(
                children: [
                  // Saving Tracker Card
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onOpenSavings,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppPalette.pureWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppPalette.line),
                          boxShadow: [
                            BoxShadow(
                              color: AppPalette.primaryDark.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppPalette.iceBlue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text('🎯',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Tabungan',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppPalette.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Rp ${Rupiah.format(totalSavings)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppPalette.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${goals.length} target aktif',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppPalette.inkSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Food Tracker Card
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onOpenOverview,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppPalette.pureWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppPalette.line),
                          boxShadow: [
                            BoxShadow(
                              color: AppPalette.primaryDark.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppPalette.iceBlue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text('🍲',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Makan & Kopi',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppPalette.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Rp ${Rupiah.format(totalFood)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppPalette.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '~Rp ${Rupiah.format(dailyFood)} / hari',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppPalette.inkSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 5. Peringatan Overbudget (Jika Ada)
              if (overBudgetCategories.isNotEmpty) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppPalette.expenseLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppPalette.expense.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppPalette.expense, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${overBudgetCategories.length} kategori melebihi anggaran bulan ini!',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppPalette.expense,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 6. Anggaran Kategori
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Anggaran Kategori',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.ink,
                    ),
                  ),
                  Text(
                    '${categories.length} Kategori',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppPalette.inkSoft,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 128,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final budget = state.getBudgetForCategory(cat.id);
                    final spent = state.totalSpentThisMonth(cat.id);
                    final maxAmount = budget?.amount ?? 0;
                    final progress =
                        maxAmount > 0 ? (spent / maxAmount).clamp(0.0, 1.0) : 0.0;
                    final isOver = maxAmount > 0 && spent > maxAmount;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailScreen(
                              state: state,
                              category: cat,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppPalette.pureWhite,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isOver ? AppPalette.expense : AppPalette.line,
                            width: isOver ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppPalette.primaryDark.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CategoryIconWidget(
                                  category: cat,
                                  size: 18,
                                  color: AppPalette.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    cat.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppPalette.ink,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rp ${Rupiah.format(spent)}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isOver
                                        ? AppPalette.expense
                                        : AppPalette.ink,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 5,
                                    backgroundColor: AppPalette.iceBlue,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isOver
                                          ? AppPalette.expense
                                          : AppPalette.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 7. Transaksi Terakhir
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaksi Terakhir',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.ink,
                    ),
                  ),
                  if (widget.onViewAllTransactions != null)
                    TextButton(
                      onPressed: widget.onViewAllTransactions,
                      style: TextButton.styleFrom(
                        foregroundColor: AppPalette.primary,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        'Lihat Semua',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              if (state.transactions.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppPalette.pureWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppPalette.line),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.receipt_long_rounded,
                          size: 36, color: AppPalette.inkLighter),
                      const SizedBox(height: 8),
                      Text(
                        'Belum ada transaksi bulan ini',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppPalette.inkSoft,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...state.transactions.take(5).map((txn) {
                  final cat = state.getCategoryById(txn.categoryId);
                  final wallet = state.getWalletById(txn.walletId);
                  return TransactionTile(
                    transaction: txn,
                    category: cat,
                    wallet: wallet,
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.label,
    required this.pct,
    required this.color,
  });

  final String label;
  final String pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label $pct',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppPalette.ink,
          ),
        ),
      ],
    );
  }
}
