# DuitAman — Personal Finance & Budget Tracker 💰

<p align="center">
  <b>Aplikasi Manajemen Finansial Pribadi Modern, Ringan, dan Terstruktur</b>
</p>

---

## 📌 Ringkasan Project

**DuitAman** adalah aplikasi mobile pengelola keuangan berbasis Flutter yang menerapkan prinsip *Clean Architecture* dan *Separation of Concerns*. Aplikasi ini dirancang untuk memudahkan pencatatan arus kas (pemasukan & pengeluaran), pemantauan saldo lintas dompet/rekening, serta alokasi anggaran bulanan dengan *commitment ring* interaktif.

---

## ✨ Fitur Utama

- 📊 **Dashboard Finansial Komprehensif:** Ringkasan sisa pagu anggaran, grafik alokasi pie chart (`fl_chart`), peringatan over-budget, dan transaksi terkini.
- 🎯 **Target Anggaran Bulanan (Budgeting):** Atur pagu per kategori pengeluaran dengan indikator komitmen visual.
- 💳 **Multi-Dompet & Rekening:** Manajemen aset likuid (Rekening Bank, E-Wallet, Uang Tunai) dengan kalkulasi saldo otomatis.
- 📝 **Pencatatan Transaksi Cepat:** Tambah pengeluaran dan pemasukan lengkap dengan kategori, dompet sumber dana, dan format rupiah otomatis.
- 🔍 **Riwayat & Filter Transaksi:** Pencarian transaksi real-time, filter jenis transaksi, dan swipe-to-delete.

---

## 🏛️ Struktur Arsitektur (Clean Code)

Kode diorganisir ke dalam layer modular yang rapi:

```text
lib/
├── core/                       # Core layer & shared utilities
│   ├── constants/             # Default master data (kategori expense & income)
│   ├── state/                 # State management (AppState ChangeNotifier)
│   ├── theme/                 # Design token (AppPalette & AppTheme)
│   └── utils/                 # Formatting Rupiah & Input Formatter
├── domain/                    # Domain Layer (Enterprise Business Entities)
│   └── entities/              # User, Wallet, Category, Budget, Transaction
└── presentation/              # Presentation Layer (UI & State bindings)
    ├── screens/               # Screen Views (Dashboard, History, Wallets, Profile, Auth)
    │   └── onboarding/        # Onboarding flow (SetInitialBudgetScreen)
    └── widgets/               # Reusable modular UI widgets (TransactionTile, CommitmentRing, dll)
```

---

## 🚀 Memulai (Getting Started)

### Prasyarat
- Flutter SDK (3.13.0 atau lebih tinggi)
- Dart SDK (^3.13.1)
- Android Studio / VS Code / Xcode

### Instalasi & Menjalankan Aplikasi
```bash
# 1. Clone repositori
git clone <repository-url>
cd duit_aman

# 2. Ambil dependencies
flutter pub get

# 3. Jalankan static analyzer & automated tests
flutter analyze
flutter test

# 4. Jalankan aplikasi
flutter run
```

---

## 🧪 Pengujian & Kualitas Kode

- **Static Analysis:** Bebas warning dan error (`flutter analyze`).
- **Unit & Widget Tests:** Pengujian UI dan flow menggunakan `flutter test`.
- **Form Validation & Formatter:** Penggunaan separator ribuan otomatis sesuai standar mata uang Rupiah Indonesia.
