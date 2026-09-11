import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/rupiah.dart';

class CommitmentRing extends StatelessWidget {
  const CommitmentRing({
    super.key,
    required this.filledCount,
    required this.totalCount,
    required this.totalAmount,
  });

  final int filledCount;
  final int totalCount;
  final int totalAmount;

  @override
  Widget build(BuildContext context) {
    final percent = totalCount == 0 ? 0 : ((filledCount / totalCount) * 100).toInt();

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: totalCount == 0 ? 0 : filledCount / totalCount,
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, fraction, child) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: AppPalette.fieldFill,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppPalette.line.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: AppPalette.forest.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 140,
              width: double.infinity,
              child: CustomPaint(
                painter: _CommitmentArcPainter(fraction: fraction),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TOTAL PAGU BULANAN',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppPalette.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Rp ${Rupiah.format(totalAmount)}',
                          style: GoogleFonts.fraunces(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.forest,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: filledCount > 0
                    ? AppPalette.forest.withValues(alpha: 0.08)
                    : AppPalette.mist.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filledCount == totalCount && totalCount > 0
                        ? Icons.check_circle_rounded
                        : Icons.pie_chart_outline_rounded,
                    size: 14,
                    color: filledCount > 0 ? AppPalette.forest : AppPalette.inkSoft,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$filledCount dari $totalCount kategori terisi ($percent%)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: filledCount > 0 ? AppPalette.forest : AppPalette.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommitmentArcPainter extends CustomPainter {
  _CommitmentArcPainter({required this.fraction});

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    final clamped = fraction.clamp(0.0, 1.0);
    final radius = math.min(size.width / 2, size.height) - strokeWidth - 2;
    final center = Offset(size.width / 2, size.height);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppPalette.line.withValues(alpha: 0.5);
    canvas.drawArc(rect, math.pi, -math.pi, false, track);

    if (clamped <= 0) return;

    final progress = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppPalette.forest;
    canvas.drawArc(rect, math.pi, -math.pi * clamped, false, progress);

    final headAngle = math.pi - math.pi * clamped;
    final head =
        center + Offset(math.cos(headAngle), math.sin(headAngle)) * radius;
    canvas.drawCircle(
      head,
      strokeWidth / 2 + 2,
      Paint()..color = AppPalette.mustard,
    );
  }

  @override
  bool shouldRepaint(_CommitmentArcPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}
