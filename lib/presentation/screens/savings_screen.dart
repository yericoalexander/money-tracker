import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/rupiah.dart';
import '../../domain/entities/saving_goal.dart';
import '../../domain/entities/wallet.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key, required this.state});

  final AppState state;

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
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

  void _showAddGoalDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    DateTime targetDate = DateTime.now().add(const Duration(days: 180));
    String selectedIcon = '🎯';

    final icons = ['🎯', '🛡️', '📱', '✈️', '🏠', '🚗', '💍', '🎓', '💻', '🏖️'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: AppPalette.pureWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppPalette.line,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tambah Impian Tabungan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Icon selector
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: icons.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final ico = icons[i];
                        final isSel = selectedIcon == ico;
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedIcon = ico),
                          child: Container(
                            width: 44,
                            decoration: BoxDecoration(
                              color: isSel
                                  ? AppPalette.iceBlue
                                  : AppPalette.fieldFill,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSel
                                    ? AppPalette.primary
                                    : AppPalette.line,
                                width: isSel ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(ico, style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Impian (contoh: Dana Darurat, Beli HP)',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Target Nominal (Rp)',
                      prefixText: 'Rp ',
                    ),
                    onChanged: (val) {
                      if (val.isEmpty) return;
                      final clean = val.replaceAll(RegExp(r'[^0-9]'), '');
                      if (clean.isEmpty) return;
                      final num = int.tryParse(clean) ?? 0;
                      final formatted = Rupiah.format(num);
                      if (formatted != val) {
                        amountController.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: targetDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (picked != null) {
                        setModalState(() => targetDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppPalette.fieldFill,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppPalette.line),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_rounded,
                              color: AppPalette.primary, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Target Tercapai: ${DateFormat('dd MMMM yyyy', 'id_ID').format(targetDate)}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppPalette.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      final amount = Rupiah.parse(amountController.text);
                      if (name.isEmpty || amount <= 0) return;

                      widget.state.addSavingGoal(
                        SavingGoal(
                          id: 'goal_${DateTime.now().millisecondsSinceEpoch}',
                          userId: widget.state.currentUserId,
                          name: name,
                          targetAmount: amount,
                          currentAmount: 0,
                          targetDate: targetDate,
                          icon: selectedIcon,
                        ),
                      );

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Target tabungan "$name" berhasil dibuat!'),
                          backgroundColor: AppPalette.primary,
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppPalette.primary,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Buat Target Tabungan'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDepositDialog(SavingGoal goal) {
    final amountController = TextEditingController();
    Wallet selectedWallet = widget.state.wallets.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: AppPalette.pureWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppPalette.line,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(goal.icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Setor ke "${goal.name}"',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nominal Setoran (Rp)',
                      prefixText: 'Rp ',
                    ),
                    onChanged: (val) {
                      if (val.isEmpty) return;
                      final clean = val.replaceAll(RegExp(r'[^0-9]'), '');
                      if (clean.isEmpty) return;
                      final num = int.tryParse(clean) ?? 0;
                      final formatted = Rupiah.format(num);
                      if (formatted != val) {
                        amountController.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<Wallet>(
                    value: selectedWallet,
                    decoration: const InputDecoration(
                      labelText: 'Sumber Saldo Dompet',
                    ),
                    items: widget.state.wallets.map((w) {
                      return DropdownMenuItem<Wallet>(
                        value: w,
                        child: Text(
                          '${w.name} (Saldo: Rp ${Rupiah.format(w.balance)})',
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => selectedWallet = val);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      final amount = Rupiah.parse(amountController.text);
                      if (amount <= 0) return;
                      if (amount > selectedWallet.balance) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Saldo dompet tidak mencukupi!'),
                            backgroundColor: AppPalette.expense,
                          ),
                        );
                        return;
                      }

                      widget.state.depositToSavingGoal(
                        goal.id,
                        amount,
                        selectedWallet.id,
                      );

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Berhasil menyetor Rp ${Rupiah.format(amount)} ke ${goal.name}',
                          ),
                          backgroundColor: AppPalette.primary,
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppPalette.primary,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Konfirmasi Setoran'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final goals = state.savingGoals;
    final totalSavings = state.totalSavingsAmount();
    final totalTarget = state.totalSavingsTarget();
    final overallProgress = totalTarget > 0 ? totalSavings / totalTarget : 0.0;

    return Scaffold(
      backgroundColor: AppPalette.canvas,
      appBar: AppBar(
        backgroundColor: AppPalette.pureWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Saving Tracker',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppPalette.ink,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showAddGoalDialog,
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: AppPalette.primary, size: 26),
            tooltip: 'Tambah Impian',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        physics: const BouncingScrollPhysics(),
        children: [
          // 1. Highlight Banner Tabungan (Blue & White Card)
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
                      'Total Tabungan Terkumpul',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.iceBlueLight.withOpacity(0.85),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(overallProgress * 100).toStringAsFixed(0)}% Target',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppPalette.pureWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${Rupiah.format(totalSavings)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppPalette.pureWhite,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: overallProgress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppPalette.sky,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target: Rp ${Rupiah.format(totalTarget)}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppPalette.iceBlueLight.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      '${goals.length} Impian Aktif',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.pureWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Header List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Target & Impian',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.ink,
                ),
              ),
              TextButton.icon(
                onPressed: _showAddGoalDialog,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Target Baru'),
                style: TextButton.styleFrom(foregroundColor: AppPalette.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // List of Goals
          if (goals.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: AppPalette.pureWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppPalette.line),
              ),
              child: Column(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'Belum Ada Target Tabungan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Mulai wujudkan impian Anda dengan membuat target tabungan pertama hari ini.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppPalette.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _showAddGoalDialog,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppPalette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Buat Target Sekarang'),
                  ),
                ],
              ),
            )
          else
            ...goals.map((goal) {
              final progress = goal.progressPercentage;
              final isAchieved = goal.isAchieved;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppPalette.pureWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAchieved ? AppPalette.income : AppPalette.line,
                    width: isAchieved ? 1.5 : 1,
                  ),
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
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: isAchieved
                                ? AppPalette.incomeLight
                                : AppPalette.iceBlue,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              goal.icon,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Target: ${DateFormat('dd MMM yyyy', 'id_ID').format(goal.targetDate)}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppPalette.inkSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isAchieved)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppPalette.incomeLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Tercapai! 🎉',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.income,
                              ),
                            ),
                          )
                        else
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppPalette.primary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppPalette.iceBlue,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isAchieved ? AppPalette.income : AppPalette.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Amounts info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terkumpul',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppPalette.inkSoft,
                              ),
                            ),
                            Text(
                              'Rp ${Rupiah.format(goal.currentAmount)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.ink,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              isAchieved ? 'Target' : 'Sisa Target',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppPalette.inkSoft,
                              ),
                            ),
                            Text(
                              isAchieved
                                  ? 'Rp ${Rupiah.format(goal.targetAmount)}'
                                  : 'Rp ${Rupiah.format(goal.remainingAmount)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isAchieved
                                    ? AppPalette.income
                                    : AppPalette.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showDepositDialog(goal),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Setor Tabungan'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppPalette.primary,
                              side: const BorderSide(color: AppPalette.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Hapus Target Tabungan?'),
                                content: Text(
                                    'Apakah Anda yakin ingin menghapus target "${goal.name}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      widget.state.deleteSavingGoal(goal.id);
                                      Navigator.pop(ctx);
                                    },
                                    style: TextButton.styleFrom(
                                        foregroundColor: AppPalette.expense),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 20, color: AppPalette.inkLighter),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
