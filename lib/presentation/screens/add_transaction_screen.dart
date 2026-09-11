import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/rupiah.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/wallet.dart';
import '../widgets/category_icon_widget.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, required this.state});

  final AppState state;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  ExpenseClassification _classification = ExpenseClassification.needs;
  MealType? _mealType = MealType.lunch;
  Category? _category;
  Wallet? _wallet;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initDefaults();
  }

  void _initDefaults() {
    final categories = _getCategories();
    _category = categories.isNotEmpty ? categories.first : null;
    _wallet =
        widget.state.wallets.isNotEmpty ? widget.state.wallets.first : null;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<Category> _getCategories() {
    return _type == TransactionType.income
        ? widget.state.incomeCategories
        : widget.state.expenseCategories;
  }

  bool get _isFoodCategory {
    final catId = _category?.id.toLowerCase() ?? '';
    return catId == 'makan' || catId == 'makanan';
  }

  void _save() {
    final amount = Rupiah.parse(_amountController.text);
    if (amount <= 0 || _category == null || _wallet == null) return;

    final newTxn = Transaction(
      id: const Uuid().v4(),
      userId: widget.state.currentUserId,
      categoryId: _category!.id,
      walletId: _wallet!.id,
      amount: amount,
      type: _type,
      date: _date,
      note: _noteController.text.trim(),
      classification: _type == TransactionType.expense
          ? _classification
          : ExpenseClassification.needs,
      mealType: _isFoodCategory ? _mealType : null,
    );

    widget.state.addTransaction(newTxn);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_type == TransactionType.income ? "Pemasukan" : "Pengeluaran"} Rp ${Rupiah.format(amount)} berhasil dicatat',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _type == TransactionType.income
            ? AppPalette.income
            : AppPalette.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getCategories();
    final isIncome = _type == TransactionType.income;

    return Scaffold(
      backgroundColor: AppPalette.canvas,
      appBar: AppBar(
        backgroundColor: AppPalette.pureWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded,
              size: 22, color: AppPalette.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Catat Transaksi',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppPalette.ink,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Selector Tipe (Pemasukan vs Pengeluaran)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppPalette.iceBlueLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppPalette.line),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _TypeButton(
                      label: 'Pengeluaran',
                      icon: Icons.arrow_upward_rounded,
                      activeColor: AppPalette.expense,
                      isSelected: !isIncome,
                      onTap: () {
                        setState(() {
                          _type = TransactionType.expense;
                          _initDefaults();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _TypeButton(
                      label: 'Pemasukan',
                      icon: Icons.arrow_downward_rounded,
                      activeColor: AppPalette.primary,
                      isSelected: isIncome,
                      onTap: () {
                        setState(() {
                          _type = TransactionType.income;
                          _initDefaults();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Input Nominal (Blue & White Card)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppPalette.pureWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppPalette.line),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.primaryDark.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nominal Transaksi',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppPalette.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Rp',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: isIncome
                              ? AppPalette.income
                              : AppPalette.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppPalette.ink,
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppPalette.inkLighter,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            fillColor: Colors.transparent,
                          ),
                          onChanged: (val) {
                            if (val.isEmpty) return;
                            final clean = val.replaceAll(RegExp(r'[^0-9]'), '');
                            if (clean.isEmpty) return;
                            final num = int.tryParse(clean) ?? 0;
                            final formatted = Rupiah.format(num);
                            if (formatted != val) {
                              _amountController.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                    offset: formatted.length),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. FITUR EXPENSE TRACKER: 3 Jenis Pengeluaran (50/30/20 Rule)
            if (!isIncome) ...[
              Text(
                'Klasifikasi Pengeluaran (Aturan 50/30/20)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.ink,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ClassificationOption(
                      title: 'Kebutuhan',
                      percentage: '50%',
                      subtitle: 'Primer/Esensial',
                      color: AppPalette.needs,
                      isSelected:
                          _classification == ExpenseClassification.needs,
                      onTap: () => setState(() =>
                          _classification = ExpenseClassification.needs),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ClassificationOption(
                      title: 'Keinginan',
                      percentage: '30%',
                      subtitle: 'Gaya Hidup',
                      color: AppPalette.wants,
                      isSelected:
                          _classification == ExpenseClassification.wants,
                      onTap: () => setState(() =>
                          _classification = ExpenseClassification.wants),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ClassificationOption(
                      title: 'Kewajiban',
                      percentage: '20%',
                      subtitle: 'Tagihan/Utang',
                      color: AppPalette.obligations,
                      isSelected: _classification ==
                          ExpenseClassification.obligations,
                      onTap: () => setState(() => _classification =
                          ExpenseClassification.obligations),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // 4. Pilih Kategori
            Text(
              'Pilih Kategori',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppPalette.ink,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = _category?.id == cat.id;

                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 76,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppPalette.primary
                            : AppPalette.pureWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppPalette.primary
                              : AppPalette.line,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppPalette.primary.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CategoryIconWidget(
                            category: cat,
                            color: isSelected
                                ? AppPalette.pureWhite
                                : AppPalette.primary,
                            size: 22,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.name,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppPalette.pureWhite
                                  : AppPalette.ink,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 5. BONUS: TRACKER PENGELUARAN MAKANAN (Food Sub-type Selector)
            if (_isFoodCategory && !isIncome) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPalette.iceBlueLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppPalette.accent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🍲', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          'Detail Waktu Makan (Food Tracker)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MealType.values.map((meal) {
                        final isSel = _mealType == meal;
                        return ChoiceChip(
                          avatar: Text(meal.icon),
                          label: Text(meal.label),
                          selected: isSel,
                          selectedColor: AppPalette.primary,
                          backgroundColor: AppPalette.pureWhite,
                          labelStyle: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight:
                                isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel
                                ? AppPalette.pureWhite
                                : AppPalette.ink,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSel
                                  ? AppPalette.primary
                                  : AppPalette.line,
                            ),
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _mealType = meal);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 6. Pilih Dompet / Rekening
            Text(
              'Pilih Dompet / Rekening',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppPalette.ink,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppPalette.pureWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppPalette.line),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Wallet>(
                  value: _wallet,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppPalette.inkSoft),
                  items: widget.state.wallets.map((w) {
                    return DropdownMenuItem<Wallet>(
                      value: w,
                      child: Row(
                        children: [
                          Icon(
                            w.type == WalletType.bank
                                ? Icons.account_balance_rounded
                                : w.type == WalletType.ewallet
                                    ? Icons.phone_android_rounded
                                    : Icons.wallet_rounded,
                            size: 18,
                            color: AppPalette.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              w.name,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.ink,
                              ),
                            ),
                          ),
                          Text(
                            'Rp ${Rupiah.format(w.balance)}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppPalette.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (w) => setState(() => _wallet = w),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 7. Tanggal Transaksi & Catatan
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppPalette.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppPalette.pureWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppPalette.line),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 18, color: AppPalette.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              DateFormat('dd MMM yyyy', 'id_ID').format(_date),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Input Catatan
            TextField(
              controller: _noteController,
              style: GoogleFonts.inter(fontSize: 14, color: AppPalette.ink),
              decoration: InputDecoration(
                hintText: 'Tambahkan catatan (opsional)...',
                hintStyle: GoogleFonts.inter(
                    fontSize: 13, color: AppPalette.inkLighter),
                prefixIcon: const Icon(Icons.edit_note_rounded,
                    color: AppPalette.inkSoft),
              ),
            ),
            const SizedBox(height: 28),

            // Tombol Simpan Transaksi
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: isIncome
                    ? AppPalette.income
                    : AppPalette.primary,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Simpan Transaksi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.pureWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.label,
    required this.icon,
    required this.activeColor,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color activeColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppPalette.pureWhite : AppPalette.inkSoft,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppPalette.pureWhite : AppPalette.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassificationOption extends StatelessWidget {
  const _ClassificationOption({
    required this.title,
    required this.percentage,
    required this.subtitle,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String percentage;
  final String subtitle;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : AppPalette.pureWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppPalette.line,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? color : AppPalette.canvas,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                percentage,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppPalette.pureWhite : AppPalette.inkSoft,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? color : AppPalette.ink,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppPalette.inkSoft,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
