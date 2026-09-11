import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../domain/entities/transaction.dart';
import '../widgets/transaction_tile.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key, required this.state});

  final AppState state;

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  List<Transaction> _filterTransactions(List<Transaction> list) {
    return list.where((t) {
      if (_selectedFilter == 'Pengeluaran' &&
          t.type != TransactionType.expense) {
        return false;
      }
      if (_selectedFilter == 'Pemasukan' && t.type != TransactionType.income) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final cat = widget.state.getCategoryById(t.categoryId);
        final noteMatch = t.note.toLowerCase().contains(query);
        final catMatch = cat.name.toLowerCase().contains(query);
        return noteMatch || catMatch;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterTransactions(widget.state.transactions);

    return Scaffold(
      backgroundColor: AppPalette.canvas,
      appBar: AppBar(
        backgroundColor: AppPalette.pureWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Riwayat Transaksi',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppPalette.ink,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input & Filter Tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppPalette.ink,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari catatan, makanan, atau kategori...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppPalette.inkSoft,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: AppPalette.primary,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter Badges
                  Row(
                    children: [
                      _FilterBadge(
                        label: 'Semua',
                        isSelected: _selectedFilter == 'Semua',
                        onTap: () => setState(() => _selectedFilter = 'Semua'),
                      ),
                      const SizedBox(width: 8),
                      _FilterBadge(
                        label: 'Pengeluaran',
                        isSelected: _selectedFilter == 'Pengeluaran',
                        onTap: () =>
                            setState(() => _selectedFilter = 'Pengeluaran'),
                      ),
                      const SizedBox(width: 8),
                      _FilterBadge(
                        label: 'Pemasukan',
                        isSelected: _selectedFilter == 'Pemasukan',
                        onTap: () =>
                            setState(() => _selectedFilter = 'Pemasukan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // List of Transactions
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: AppPalette.inkLighter,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada transaksi ditemukan',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppPalette.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final txn = filtered[index];
                        final cat = widget.state.getCategoryById(txn.categoryId);
                        final wallet = widget.state.getWalletById(txn.walletId);

                        return Dismissible(
                          key: Key(txn.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppPalette.expense,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            widget.state.deleteTransaction(txn.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Transaksi berhasil dihapus'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: TransactionTile(
                            transaction: txn,
                            category: cat,
                            wallet: wallet,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBadge extends StatelessWidget {
  const _FilterBadge({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppPalette.primary : AppPalette.iceBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppPalette.pureWhite : AppPalette.ink,
          ),
        ),
      ),
    );
  }
}
