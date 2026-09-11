import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/rupiah.dart';
import '../../domain/entities/transaction.dart';

class FinancialOverviewScreen extends StatefulWidget {
  const FinancialOverviewScreen({super.key, required this.state});

  final AppState state;

  @override
  State<FinancialOverviewScreen> createState() =>
      _FinancialOverviewScreenState();
}

class _FinancialOverviewScreenState extends State<FinancialOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final income = state.totalIncomeThisMonth();
    final expense = state.totalExpenseThisMonth();
    final netCashflow = income - expense;
    final healthScore = state.financialHealthScore();
    final healthStatus = state.financialHealthStatus();
    final healthInsight = state.financialHealthInsight();

    // 3-Types Data (50/30/20)
    final needs = state.totalNeedsThisMonth();
    final wants = state.totalWantsThisMonth();
    final obligations = state.totalObligationsThisMonth();
    final totalClassified = needs + wants + obligations;

    // Food Tracker Data
    final totalFood = state.totalFoodExpenseThisMonth();
    final dailyFoodAvg = state.averageDailyFoodExpense();
    final foodBreakdown = state.foodExpenseByMealType();

    return Scaffold(
      backgroundColor: AppPalette.canvas,
      appBar: AppBar(
        backgroundColor: AppPalette.pureWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Financial Overview & Chart',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppPalette.ink,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        physics: const BouncingScrollPhysics(),
        children: [
          // 1. FINANCIAL HEALTH SCORE CARD (Blue Gradient & White)
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
                  color: AppPalette.primary.withOpacity(0.25),
                  blurRadius: 18,
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
                      'Skor Kesehatan Finansial',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.iceBlueLight.withOpacity(0.9),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        healthStatus,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppPalette.pureWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppPalette.sky,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$healthScore',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppPalette.pureWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Arus Kas Bersih',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppPalette.iceBlueLight.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            'Rp ${Rupiah.format(netCashflow)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppPalette.pureWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded,
                          size: 18, color: AppPalette.sky),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          healthInsight,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 1.4,
                            color: AppPalette.pureWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. AUTO FINANCIAL CHART: CASHFLOW BAR CHART (Pemasukan vs Pengeluaran)
          Text(
            'Grafik Arus Kas Otomatis',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppPalette.ink,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.pureWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppPalette.line),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.primaryDark.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
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
                      'Pemasukan vs Pengeluaran Bulan Ini',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.inkSoft,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (income > expense ? income : expense) * 1.2,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final isInc = rodIndex == 0;
                            return BarTooltipItem(
                              '${isInc ? "Masuk" : "Keluar"}\nRp ${Rupiah.format(rod.toY.toInt())}',
                              GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  val.toInt() == 0 ? 'Pemasukan' : 'Pengeluaran',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppPalette.ink,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: income.toDouble(),
                              color: AppPalette.primary,
                              width: 32,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: expense.toDouble(),
                              color: AppPalette.expense,
                              width: 32,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MetricChip(
                      label: 'Total Pemasukan',
                      amount: 'Rp ${Rupiah.format(income)}',
                      color: AppPalette.primary,
                      icon: Icons.arrow_downward_rounded,
                    ),
                    _MetricChip(
                      label: 'Total Pengeluaran',
                      amount: 'Rp ${Rupiah.format(expense)}',
                      color: AppPalette.expense,
                      icon: Icons.arrow_upward_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. AUTO FINANCIAL CHART: ATURAN 50/30/20 (DONUT CHART)
          Text(
            'Proporsi 3 Jenis Pengeluaran (50/30/20)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppPalette.ink,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.pureWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppPalette.line),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.primaryDark.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (totalClassified == 0)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Belum ada transaksi pengeluaran terklasifikasi.',
                        style: GoogleFonts.inter(color: AppPalette.inkSoft),
                      ),
                    ),
                  )
                else ...[
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 46,
                        sections: [
                          if (needs > 0)
                            PieChartSectionData(
                              color: AppPalette.needs,
                              value: needs.toDouble(),
                              title:
                                  '${((needs / totalClassified) * 100).toStringAsFixed(0)}%',
                              radius: 36,
                              titleStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          if (wants > 0)
                            PieChartSectionData(
                              color: AppPalette.wants,
                              value: wants.toDouble(),
                              title:
                                  '${((wants / totalClassified) * 100).toStringAsFixed(0)}%',
                              radius: 36,
                              titleStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          if (obligations > 0)
                            PieChartSectionData(
                              color: AppPalette.obligations,
                              value: obligations.toDouble(),
                              title:
                                  '${((obligations / totalClassified) * 100).toStringAsFixed(0)}%',
                              radius: 36,
                              titleStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ClassificationRow(
                    title: 'Kebutuhan (Needs - Ideal 50%)',
                    amount: needs,
                    total: totalClassified,
                    color: AppPalette.needs,
                  ),
                  const SizedBox(height: 8),
                  _ClassificationRow(
                    title: 'Keinginan (Wants - Ideal 30%)',
                    amount: wants,
                    total: totalClassified,
                    color: AppPalette.wants,
                  ),
                  const SizedBox(height: 8),
                  _ClassificationRow(
                    title: 'Kewajiban (Obligations - Ideal 20%)',
                    amount: obligations,
                    total: totalClassified,
                    color: AppPalette.obligations,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. BONUS FITUR: TRACKER PENGELUARAN MAKAN (Food Expense Breakdown)
          Text(
            'Detail Pengeluaran Makanan (Food Tracker)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppPalette.ink,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.pureWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppPalette.line),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.primaryDark.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Makan Bulan Ini',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppPalette.inkSoft,
                          ),
                        ),
                        Text(
                          'Rp ${Rupiah.format(totalFood)}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppPalette.primary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppPalette.iceBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rata-rata / Hari',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppPalette.inkSoft,
                            ),
                          ),
                          Text(
                            'Rp ${Rupiah.format(dailyFoodAvg)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppPalette.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  'Breakdown Waktu Makan & Belanja:',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.inkSoft,
                  ),
                ),
                const SizedBox(height: 10),
                ...MealType.values.map((meal) {
                  final amt = foodBreakdown[meal] ?? 0;
                  final pct = totalFood > 0 ? (amt / totalFood) : 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Text(meal.icon, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: Text(
                            meal.label,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppPalette.ink,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 6,
                              backgroundColor: AppPalette.iceBlue,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppPalette.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Rp ${Rupiah.format(amt)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppPalette.ink,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String label;
  final String amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppPalette.inkSoft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ClassificationRow extends StatelessWidget {
  const _ClassificationRow({
    required this.title,
    required this.amount,
    required this.total,
    required this.color,
  });

  final String title;
  final int amount;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? ((amount / total) * 100).toStringAsFixed(0) : '0';
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppPalette.ink,
            ),
          ),
        ),
        Text(
          'Rp ${Rupiah.format(amount)} ($pct%)',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
