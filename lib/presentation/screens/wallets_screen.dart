import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/rupiah.dart';
import '../../domain/entities/wallet.dart';

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.paper,
      appBar: AppBar(
        backgroundColor: AppPalette.paper,
        elevation: 0,
        title: Text(
          'Dompet & Rekening',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppPalette.forest,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                size: 22, color: AppPalette.forest),
            onPressed: () => _showAddWalletDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          children: [
            // Total Asset Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppPalette.forest,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Saldo Likuid',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppPalette.mist.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${Rupiah.format(state.totalWalletBalance())}',
                    style: GoogleFonts.fraunces(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.paper,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'DAFTAR DOMPET AKTIF',
              style: GoogleFonts.inter(
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: AppPalette.forest,
              ),
            ),
            const SizedBox(height: 12),

            ...state.wallets.map((w) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPalette.fieldFill,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppPalette.line),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppPalette.mist,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _walletIcon(w.type),
                        color: AppPalette.forest,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppPalette.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            w.type.label,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: AppPalette.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rp ${Rupiah.format(w.balance)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppPalette.forest,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  IconData _walletIcon(WalletType type) {
    switch (type) {
      case WalletType.cash:
        return Icons.payments_outlined;
      case WalletType.bank:
        return Icons.account_balance_outlined;
      case WalletType.ewallet:
        return Icons.phone_android_rounded;
    }
  }

  void _showAddWalletDialog(BuildContext context) {
    final nameController = TextEditingController();
    final balanceController = TextEditingController();
    WalletType selectedType = WalletType.bank;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tambah Dompet / Rekening',
                    style: GoogleFonts.fraunces(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.forest,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Dompet (misal: BCA, Dompet Tunai)',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: balanceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [ThousandsSeparatorInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Saldo Awal',
                      prefixText: 'Rp ',
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<WalletType>(
                    initialValue: selectedType,
                    decoration: const InputDecoration(labelText: 'Tipe Akun'),
                    items: const [
                      DropdownMenuItem(
                        value: WalletType.bank,
                        child: Text('Rekening Bank'),
                      ),
                      DropdownMenuItem(
                        value: WalletType.ewallet,
                        child: Text('E-Wallet'),
                      ),
                      DropdownMenuItem(
                        value: WalletType.cash,
                        child: Text('Uang Tunai'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => selectedType = val);
                      }
                    },
                  ),
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      final balance = Rupiah.parse(balanceController.text);
                      if (name.isNotEmpty) {
                        state.addWallet(name, selectedType, balance);
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Simpan Dompet'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
