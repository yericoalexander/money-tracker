import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../widgets/circular_notched_shape.dart';
import 'add_transaction_screen.dart';
import 'dashboard_screen.dart';
import 'financial_overview_screen.dart';
import 'savings_screen.dart';
import 'transaction_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.state});

  final AppState state;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onStateChange);
  }

  @override
  void dispose() {
    widget.state.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  void _openAddTransactionModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(state: widget.state),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        state: widget.state,
        onViewAllTransactions: () => setState(() => _index = 3),
        onOpenSavings: () => setState(() => _index = 1),
        onOpenOverview: () => setState(() => _index = 2),
      ),
      SavingsScreen(state: widget.state),
      FinancialOverviewScreen(state: widget.state),
      TransactionHistoryScreen(state: widget.state),
    ];

    return Scaffold(
      backgroundColor: AppPalette.canvas,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          color: AppPalette.canvas,
          child: IndexedStack(index: _index, children: screens),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransactionModal,
        backgroundColor: AppPalette.primary,
        foregroundColor: AppPalette.pureWhite,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1.0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          child: BottomAppBar(
            elevation: 10,
            color: AppPalette.pureWhite,
            surfaceTintColor: Colors.transparent,
            shadowColor: AppPalette.primaryDark.withOpacity(0.12),
            notchMargin: 8,
            shape: const CircularNotchedAndCorneredRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Dashboard',
                  selected: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
                _NavItem(
                  icon: Icons.savings_rounded,
                  label: 'Tabungan',
                  selected: _index == 1,
                  onTap: () => setState(() => _index = 1),
                ),
                const SizedBox(width: 48), // Gap for docked FAB
                _NavItem(
                  icon: Icons.insights_rounded,
                  label: 'Evaluasi',
                  selected: _index == 2,
                  onTap: () => setState(() => _index = 2),
                ),
                _NavItem(
                  icon: Icons.receipt_long_rounded,
                  label: 'Riwayat',
                  selected: _index == 3,
                  onTap: () => setState(() => _index = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? AppPalette.primary : AppPalette.inkSoft,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppPalette.primary : AppPalette.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
