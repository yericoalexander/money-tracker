import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_palette.dart';
import '../../domain/entities/category.dart';

class CategoryIconWidget extends StatelessWidget {
  const CategoryIconWidget({
    super.key,
    required this.category,
    this.size = 20,
    this.color = AppPalette.forest,
  });

  final Category category;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (category.iconAsset.endsWith('.svg')) {
      return SvgPicture.asset(
        category.iconAsset,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        placeholderBuilder: (context) => Icon(
          _fallbackIcon(category.id),
          size: size,
          color: color,
        ),
      );
    }
    return Icon(
      _fallbackIcon(category.id),
      size: size,
      color: color,
    );
  }

  IconData _fallbackIcon(String id) {
    switch (id) {
      case 'makan':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_filled_rounded;
      case 'belanja':
        return Icons.shopping_bag_rounded;
      case 'tagihan':
        return Icons.receipt_long_rounded;
      case 'hiburan':
        return Icons.movie_filter_rounded;
      case 'kesehatan':
        return Icons.medical_services_rounded;
      case 'pendidikan':
        return Icons.school_rounded;
      case 'gaji':
        return Icons.payments_rounded;
      case 'freelance':
        return Icons.laptop_mac_rounded;
      case 'investasi':
        return Icons.trending_up_rounded;
      case 'bonus':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
