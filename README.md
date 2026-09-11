# DuitAman

A modular personal finance and budgeting mobile application built with **Flutter**, designed around the **50/30/20 budgeting rule**, target-driven savings tracking, automated cashflow visualization, and a modern **Blue & White** design system.

---

## Key Capabilities

- **Income Tracking:** Real-time revenue logging with categorized income sources (Salary, Freelance, Investments, Business, Bonuses) linked directly to multi-asset wallets.
- **Target-Driven Savings Tracker:** Dedicated goals management featuring target amounts, deadlines, visual progress bars, and instantaneous one-tap deposits from liquid accounts.
- **50/30/20 Expense Classification:** Automatic tagging and distribution tracking across:
  - `Needs (50%)`: Essential living costs (Groceries, Utilities, Rent, Transport).
  - `Wants (30%)`: Lifestyle, leisure, dining out, and entertainment.
  - `Obligations (20%)`: Debt servicing, recurring commitments, and scheduled insurance.
- **Granular Food Expense Auditing:** Sub-categorization for dining expenditures by meal period (`Breakfast`, `Lunch`, `Dinner`, `Snack & Coffee`, `Groceries`) with daily run-rate analytics.
- **Financial Health Scoring:** Deterministic algorithm (scale 10–100) assessing savings rate, expense-to-income ratios, and cashflow surplus/deficit status.
- **Automated Financial Charts:** Dynamic Bar Charts for monthly cashflow comparison and Donut Charts for 50/30/20 allocation breakdowns powered by `fl_chart`.
- **Multi-Wallet Architecture:** Support for Cash, Bank Accounts (BCA, Mandiri, etc.), and E-Wallets (GoPay, OVO) with automatic double-entry balance updates.

---

## Design System & Palette

The user interface follows a clean, high-contrast **Blue & White** aesthetic engineered for visual comfort and trust:

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#1565C0` | Primary brand accent, main action buttons, active navigation |
| `primaryDark` | `#0D47A1` | Surface headers, hero cards gradient start |
| `accent` | `#0284C7` | Highlight badges, progress fills |
| `canvas` | `#F8FAFC` | Global scaffold background |
| `pureWhite` | `#FFFFFF` | Card surfaces, dialog backgrounds, input fields |
| `ink` | `#0F172A` | Primary typography (`Plus Jakarta Sans` / `Inter`) |
| `inkSoft` | `#64748B` | Secondary labels, subtitle metadata |
| `line` | `#E2E8F0` | Structural card borders and dividers |
| `income` | `#10B981` | Credit transactions, positive delta indicators |
| `expense` | `#EF4444` | Debit transactions, budget deficit warnings |

---

## Architecture Overview

The codebase is organized following Clean Architecture conventions:

```text
lib/
├── core/
│   ├── constants/             # Default category presets and app constants
│   ├── state/                 # Application state container (ChangeNotifier)
│   ├── theme/                 # Design system tokens (AppPalette & AppTheme)
│   └── utils/                 # Currency parser and Indonesian Rupiah formatter
├── domain/
│   └── entities/              # Core business entities
│       ├── budget.dart        # Category monthly spending limits
│       ├── category.dart      # Income and expense category schemas
│       ├── saving_goal.dart   # Savings target and progress metrics
│       ├── transaction.dart   # Ledger model with 50/30/20 & meal type enums
│       ├── user.dart          # User identity model
│       └── wallet.dart        # Account ledger and balance definitions
└── presentation/
    ├── screens/               # Application view controllers
    │   ├── add_transaction_screen.dart   # Transaction intake modal
    │   ├── category_detail_screen.dart   # Category expenditure breakdown
    │   ├── dashboard_screen.dart         # Primary overview & metrics
    │   ├── financial_overview_screen.dart# Health score & auto charts
    │   ├── home_screen.dart              # Root navigation shell & docked FAB
    │   ├── login_screen.dart             # Authentication & onboarding entry
    │   ├── savings_screen.dart           # Goal tracker & quick deposit modal
    │   ├── transaction_history_screen.dart # Searchable transaction ledger
    │   └── wallets_screen.dart           # Wallet balance management
    └── widgets/               # Reusable UI components
        ├── category_icon_widget.dart     # Vector SVG / fallback icon loader
        ├── circular_notched_shape.dart   # Custom bottom navigation bar shape
        └── transaction_tile.dart         # Responsive non-overflowing ledger item
```

---

## Getting Started

### Prerequisites
- **Flutter SDK:** `>= 3.13.0` (Dart SDK `>= 3.13.1`)
- **Xcode:** `>= 15.0` (for iOS deployment)
- **CocoaPods:** Optional (Project configured with SPM / standard runner)

### Installation & Run

1. Clone the repository:
   ```bash
   git clone https://github.com/yericoalexander/money-tracker.git
   cd money-tracker
   ```

2. Fetch dependencies:
   ```bash
   flutter pub get
   ```

3. Validate code quality:
   ```bash
   flutter analyze
   flutter test
   ```

4. Launch on a connected device:
   ```bash
   # Run on connected iOS device
   flutter run -d <device_id>

   # Run in release mode for production performance
   flutter run -d <device_id> --release
   ```

---

## Verification & Testing

The repository contains automated unit and widget test suites covering:
- Savings goal progress and deposit calculations.
- 50/30/20 expense classification calculations.
- Granular meal time breakdowns and daily averages.
- Financial health scoring bounds (10–100) and insight generation.

Run the test suite with:
```bash
flutter test
```

---

## License

This project is proprietary and maintained for personal financial tracking.
