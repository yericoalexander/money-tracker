import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/default_categories.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/utils/rupiah.dart';
import '../../widgets/category_budget_field.dart';
import '../../widgets/commitment_ring.dart';
import '../home_screen.dart';

class SetInitialBudgetScreen extends StatefulWidget {
  const SetInitialBudgetScreen({super.key, required this.state});

  final AppState state;

  @override
  State<SetInitialBudgetScreen> createState() => _SetInitialBudgetScreenState();
}

class _SetInitialBudgetScreenState extends State<SetInitialBudgetScreen> {
  final Map<String, int> _amounts = {};

  @override
  void initState() {
    super.initState();
    for (final b in widget.state.budgets) {
      _amounts[b.categoryId] = b.amount;
    }
  }

  int get _total => _amounts.values.fold(0, (sum, value) => sum + value);

  int get _filledCount => _amounts.values.where((value) => value > 0).length;

  void _onChanged(String categoryId, int value) {
    setState(() => _amounts[categoryId] = value);
  }

  void _save() {
    for (final entry in _amounts.entries) {
      widget.state.setOrUpdateBudget(entry.key, entry.value);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Budget awal berhasil disimpan · Total Rp ${Rupiah.format(_total)}/bulan',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppPalette.forest,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(state: widget.state),
      ),
    );
  }

  void _setPresetHealthy() {
    final presets = <String, int>{
      'makan': 2500000,
      'transport': 750000,
      'belanja': 1200000,
      'tagihan': 1000000,
      'hiburan': 500000,
      'kesehatan': 400000,
      'pendidikan': 600000,
      'lainnya': 250000,
    };
    setState(() {
      _amounts.addAll(presets);
    });
  }

  void _clearAll() {
    setState(() {
      _amounts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = kDefaultExpenseCategories;

    return Scaffold(
      backgroundColor: AppPalette.paper,
      appBar: AppBar(
        backgroundColor: AppPalette.paper,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppPalette.forest),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(state: widget.state),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(state: widget.state),
                ),
              );
            },
            child: Text(
              'Lewati',
              style: GoogleFonts.inter(
                color: AppPalette.inkSoft,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Atur Budget Awalmu',
                style: GoogleFonts.fraunces(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.ink,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tentukan pagu pengeluaran bulanan agar keuanganmu tetap aman dan terkontrol.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppPalette.inkSoft,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),

              // Signature Motion Commitment Arc (Card Bersih Modern)
              CommitmentRing(
                filledCount: _filledCount,
                totalCount: categories.length,
                totalAmount: _total,
              ),
              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KATEGORI PENGELUARAN',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.forest,
                    ),
                  ),
                  Row(
                    children: [
                      if (_filledCount > 0) ...[
                        InkWell(
                          onTap: _clearAll,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            child: Text(
                              'Reset',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.brick,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      InkWell(
                        onTap: _setPresetHealthy,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppPalette.mustard.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_fix_high_rounded,
                                  size: 13, color: AppPalette.forest),
                              const SizedBox(width: 4),
                              Text(
                                'Preset',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.forest,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: AppPalette.paper,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < categories.length; i++)
                      CategoryBudgetField(
                        category: categories[i],
                        value: _amounts[categories[i].id] ?? 0,
                        onChanged: (value) =>
                            _onChanged(categories[i].id, value),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              FilledButton(
                onPressed: _total > 0 ? _save : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppPalette.forest,
                  foregroundColor: AppPalette.paper,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Simpan & Lanjutkan ke Dashboard',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
              .moveY(
                begin: 16,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutCubic,
              ),
        ),
      ),
    );
  }
}
