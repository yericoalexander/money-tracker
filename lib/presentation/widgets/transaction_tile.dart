import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/rupiah.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/wallet.dart';
import 'category_icon_widget.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.category,
    required this.wallet,
    this.onTap,
    this.compact = false,
  });

  final Transaction transaction;
  final Category category;
  final Wallet wallet;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    // Classification badge color
    Color classificationColor = AppPalette.needs;
    if (transaction.classification == ExpenseClassification.wants) {
      classificationColor = AppPalette.wants;
    } else if (transaction.classification == ExpenseClassification.obligations) {
      classificationColor = AppPalette.obligations;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.line),
        boxShadow: [
          BoxShadow(
            color: AppPalette.primaryDark.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: compact ? 10 : 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Category Icon
                Container(
                  width: compact ? 38 : 42,
                  height: compact ? 38 : 42,
                  decoration: BoxDecoration(
                    color:
                        isIncome ? AppPalette.incomeLight : AppPalette.iceBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: CategoryIconWidget(
                    category: category,
                    size: compact ? 18 : 20,
                    color: isIncome ? AppPalette.income : AppPalette.primary,
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Middle Content (Strictly Expanded to prevent any RenderFlex overflow)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Line 1: Category Name + 3-Type Badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              category.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.ink,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isIncome) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    classificationColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                transaction.classification.label,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: classificationColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Line 2: Note (if any)
                      if (transaction.note.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          transaction.note,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppPalette.ink,
                          ),
                        ),
                      ],

                      const SizedBox(height: 3),

                      // Line 3: Meal Tag + Wallet + Date
                      Row(
                        children: [
                          if (transaction.mealType != null) ...[
                            Text(
                              '${transaction.mealType!.icon} ${transaction.mealType!.label}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.primary,
                              ),
                            ),
                            Text(
                              ' · ',
                              style: GoogleFonts.inter(color: AppPalette.inkSoft),
                            ),
                          ],
                          Flexible(
                            child: Text(
                              wallet.name,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppPalette.inkSoft,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            ' · ${dateFormat.format(transaction.date)}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppPalette.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Amount Trailing
                Text(
                  '${isIncome ? '+' : '-'} Rp ${Rupiah.format(transaction.amount)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isIncome ? AppPalette.income : AppPalette.expense,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
