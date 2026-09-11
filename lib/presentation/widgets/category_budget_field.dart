import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/rupiah.dart';
import '../../domain/entities/category.dart';

class CategoryBudgetField extends StatefulWidget {
  const CategoryBudgetField({
    super.key,
    required this.category,
    required this.value,
    required this.onChanged,
  });

  final Category category;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<CategoryBudgetField> createState() => _CategoryBudgetFieldState();
}

class _CategoryBudgetFieldState extends State<CategoryBudgetField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value > 0 ? Rupiah.format(widget.value) : '',
    );
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(covariant CategoryBudgetField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final text = widget.value > 0 ? Rupiah.format(widget.value) : '';
      if (_controller.text != text) {
        _controller.text = text;
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final isFilled = widget.value > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _isFocused
            ? AppPalette.forest.withValues(alpha: 0.03)
            : (isFilled ? AppPalette.fieldFill : Colors.transparent),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? AppPalette.forest
              : (isFilled ? AppPalette.line : AppPalette.line.withValues(alpha: 0.4)),
          width: _isFocused ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isFilled ? AppPalette.mist : AppPalette.paper,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFilled
                    ? AppPalette.forest.withValues(alpha: 0.2)
                    : AppPalette.line,
              ),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              category.iconAsset,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                isFilled ? AppPalette.forest : AppPalette.inkSoft,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isFilled ? FontWeight.w700 : FontWeight.w600,
                color: isFilled ? AppPalette.ink : AppPalette.inkSoft,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 145,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isFilled ? AppPalette.paper : AppPalette.fieldFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isFocused ? AppPalette.forest : AppPalette.line,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Rp',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isFilled ? AppPalette.forest : AppPalette.inkSoft,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [ThousandsSeparatorInputFormatter()],
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isFilled ? AppPalette.forest : AppPalette.ink,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      hintText: '0',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.inkSoft.withValues(alpha: 0.4),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                    onChanged: (_) {
                      widget.onChanged(Rupiah.parse(_controller.text));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
