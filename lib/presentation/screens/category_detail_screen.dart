import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/rupiah.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../widgets/category_icon_widget.dart';
import '../widgets/transaction_tile.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({
    super.key,
    required this.category,
    required this.state,
  });

  final Category category;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final budget = state.getBudgetForCategory(category.id)?.amount ?? 0;
    final spent = state.totalSpentThisMonth(category.id);
    final remaining = budget - spent;
    final double percent =
        budget > 0 ? (spent / budget).clamp(0.0, 1.0) : (spent > 0 ? 1.0 : 0.0);
    final isOver = budget > 0 && spent > budget;

    final txns = state.transactions
        .where((t) =>
            t.categoryId == category.id &&
            t.type == TransactionType.expense &&
            t.date.month == DateTime.now().month &&
            t.date.year == DateTime.now().year)
        .toList();

    return Scaffold(
      backgroundColor: AppPalette.paper,
      appBar: AppBar(
        backgroundColor: AppPalette.paper,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppPalette.forest),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category.name,
          style: GoogleFonts.fraunces(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppPalette.forest,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded,
                size: 24, color: AppPalette.forest),
            onPressed: () => _showEditBudgetDialog(context, budget),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isOver ? AppPalette.brick : AppPalette.forest,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppPalette.paper.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: CategoryIconWidget(
                          category: category,
                          size: 22,
                          color: AppPalette.paper,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: GoogleFonts.fraunces(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.paper,
                              ),
                            ),
                            Text(
                              isOver
                                  ? 'Melebihi target anggaran'
                                  : '${(percent * 100).toInt()}% dari target terpakai',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppPalette.mist.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sisa Budget
                  Text(
                    isOver ? 'Kelebihan Pengeluaran' : 'Sisa Budget Kategori',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: AppPalette.mist.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp ${Rupiah.format(remaining.abs())}',
                    style: GoogleFonts.fraunces(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.paper,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 8,
                      backgroundColor: Colors.black26,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOver ? Colors.white : AppPalette.mustard,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Terpakai: Rp ${Rupiah.format(spent)}',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: AppPalette.mist.withValues(alpha: 0.9),
                        ),
                      ),
                      Text(
                        'Target: Rp ${Rupiah.format(budget)}',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.mist.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Header Daftar Transaksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TRANSAKSI DI KATEGORI INI',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.forest,
                  ),
                ),
                Text(
                  '${txns.length} transaksi',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.inkSoft,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (txns.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppPalette.fieldFill,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppPalette.line),
                ),
                child: Center(
                  child: Text(
                    'Belum ada transaksi di kategori ini',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppPalette.inkSoft,
                    ),
                  ),
                ),
              )
            else
              ...txns.map((txn) {
                final wallet = state.getWalletById(txn.walletId);
                return TransactionTile(
                  transaction: txn,
                  category: category,
                  wallet: wallet,
                );
              }),
          ],
        )
            .animate()
            .fadeIn(duration: 350.ms, curve: Curves.easeOutCubic),
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, int currentBudget) {
    final controller = TextEditingController(
      text: currentBudget > 0 ? Rupiah.format(currentBudget) : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppPalette.fieldFill,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Ubah Target Budget',
            style: GoogleFonts.fraunces(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppPalette.forest,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.ink,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                inputFormatters: const [ThousandsSeparatorInputFormatter()],
                decoration: const InputDecoration(
                  prefixText: 'Rp ',
                  hintText: '0',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Batal',
                style: GoogleFonts.inter(color: AppPalette.inkSoft),
              ),
            ),
            FilledButton(
              onPressed: () {
                final val = Rupiah.parse(controller.text);
                state.setOrUpdateBudget(category.id, val);
                Navigator.pop(ctx);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppPalette.forest,
                foregroundColor: AppPalette.paper,
                minimumSize: const Size(80, 40),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
