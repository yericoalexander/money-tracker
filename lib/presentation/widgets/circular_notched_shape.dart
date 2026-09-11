import 'package:flutter/material.dart';

class CircularNotchedAndCorneredRectangle extends NotchedShape {
  const CircularNotchedAndCorneredRectangle();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }
    const notchRadius = 32.0;
    final target = guest.center;

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(target.dx - notchRadius * 1.4, host.top)
      ..quadraticBezierTo(
        target.dx - notchRadius,
        host.top,
        target.dx - notchRadius * 0.8,
        host.top + 10,
      )
      ..arcToPoint(
        Offset(target.dx + notchRadius * 0.8, host.top + 10),
        radius: const Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(
        target.dx + notchRadius,
        host.top,
        target.dx + notchRadius * 1.4,
        host.top,
      )
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
