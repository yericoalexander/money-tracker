import 'package:flutter/material.dart';

abstract final class AppPalette {
  // Brand Main Accent (Modern Blue & White)
  static const primary = Color(0xFF1565C0); // Deep Trust Blue
  static const primaryDark = Color(0xFF0D47A1); // Royal Navy Blue
  static const primaryLight = Color(0xFF1E88E5); // Vibrant Blue
  static const accent = Color(0xFF0284C7); // Sky / Electric Cyan
  static const sky = Color(0xFF38BDF8); // Soft Sky Accent

  // Background & Surfaces (Clean White & Soft Ice Blue)
  static const canvas = Color(0xFFF8FAFC); // Very Soft Blue-Grey / Off-White
  static const pureWhite = Color(0xFFFFFFFF); // Pure White
  static const iceBlue = Color(0xFFEBF3FE); // Ice Blue Pill / Container
  static const iceBlueLight = Color(0xFFF0F7FF); // Ultra Soft Blue Tint
  static const cardSurface = Color(0xFFFFFFFF); // White Card Surface
  static const darkSurface = Color(0xFF0A192F); // Deep Navy Surface for contrast

  // Text & Neutral Colors
  static const ink = Color(0xFF0F172A); // Slate 900 (High contrast text)
  static const inkSoft = Color(0xFF64748B); // Slate 500 (Subdued text)
  static const inkLighter = Color(0xFF94A3B8); // Slate 400 (Placeholder text)
  static const line = Color(0xFFE2E8F0); // Subtle Slate Border
  static const fieldFill = Color(0xFFF8FAFC); // Soft Field Background

  // Financial Status Colors
  static const income = Color(0xFF10B981); // Emerald Green
  static const incomeLight = Color(0xFFE8FDF3); // Soft Green Fill
  static const expense = Color(0xFFEF4444); // Coral Red
  static const expenseLight = Color(0xFFFEF2F2); // Soft Red Fill
  static const warning = Color(0xFFF59E0B); // Amber / Warning
  static const warningLight = Color(0xFFFFFBEB); // Soft Amber Fill

  // 3-Type Expense Classification Colors (50/30/20 Rule)
  static const needs = Color(0xFF1565C0); // Blue (Kebutuhan Pokok 50%)
  static const needsLight = Color(0xFFEBF3FE);
  static const wants = Color(0xFFF59E0B); // Amber (Keinginan 30%)
  static const wantsLight = Color(0xFFFFF7ED);
  static const obligations = Color(0xFF8B5CF6); // Purple (Kewajiban 20%)
  static const obligationsLight = Color(0xFFF5F3FF);

  // Meal Types Colors for Food Expense Tracker
  static const mealBreakfast = Color(0xFFF59E0B); // Morning Sun Amber
  static const mealLunch = Color(0xFF0284C7); // Midday Sky Blue
  static const mealDinner = Color(0xFF4F46E5); // Evening Indigo
  static const mealSnack = Color(0xFFEC4899); // Pink Rose
  static const mealGroceries = Color(0xFF10B981); // Fresh Green

  // Category Color Palette
  static const categoryFood = Color(0xFF0284C7);
  static const categoryTransport = Color(0xFF2563EB);
  static const categoryShopping = Color(0xFF8B5CF6);
  static const categoryBills = Color(0xFFDC2626);
  static const categoryEntertainment = Color(0xFFF59E0B);
  static const categoryHealth = Color(0xFF10B981);
  static const categoryEducation = Color(0xFF0D9488);
  static const categorySaving = Color(0xFF1565C0);
  static const categoryOther = Color(0xFF64748B);

  // Legacy mappings for backwards compatibility
  static const forest = primary;
  static const sage = accent;
  static const lightSage = sky;
  static const paper = canvas;
  static const mustard = warning;
  static const brick = expense;
  static const mist = iceBlue;

  static Color forCategory(String id) {
    switch (id.toLowerCase()) {
      case 'makan':
      case 'makanan':
        return categoryFood;
      case 'transport':
      case 'transportasi':
        return categoryTransport;
      case 'belanja':
        return categoryShopping;
      case 'tagihan':
      case 'kewajiban':
        return categoryBills;
      case 'hiburan':
        return categoryEntertainment;
      case 'kesehatan':
        return categoryHealth;
      case 'pendidikan':
        return categoryEducation;
      case 'tabungan':
      case 'investasi':
        return categorySaving;
      case 'gaji':
      case 'freelance':
      case 'bonus':
        return income;
      case 'lainnya':
      default:
        return categoryOther;
    }
  }
}
