import '../../domain/entities/category.dart';

const List<Category> kDefaultExpenseCategories = [
  Category(
    id: 'makan',
    name: 'Makan & Minum',
    iconAsset: 'assets/icons/makan.svg',
    type: CategoryType.expense,
    isDefault: true,
  ),
  Category(
    id: 'transport',
    name: 'Transportasi',
    iconAsset: 'assets/icons/transport.svg',
    type: CategoryType.expense,
    isDefault: true,
  ),
  Category(
    id: 'belanja',
    name: 'Belanja',
    iconAsset: 'assets/icons/belanja.svg',
    type: CategoryType.expense,
    isDefault: true,
  ),
  Category(
    id: 'tagihan',
    name: 'Tagihan & Utilitas',
    iconAsset: 'assets/icons/tagihan.svg',
    type: CategoryType.expense,
    isDefault: true,
  ),
  Category(
    id: 'hiburan',
    name: 'Hiburan',
    iconAsset: 'assets/icons/hiburan.svg',
    type: CategoryType.expense,
    isDefault: true,
  ),
  Category(
    id: 'kesehatan',
    name: 'Kesehatan',
    iconAsset: 'assets/icons/kesehatan.svg',
    type: CategoryType.expense,
    isDefault: true,
  ),
  Category(
    id: 'pendidikan',
    name: 'Pendidikan',
    iconAsset: 'assets/icons/pendidikan.svg',
    type: CategoryType.expense,
    isDefault: true,
  ),
  Category(
    id: 'lainnya',
    name: 'Lain-lain',
    iconAsset: 'assets/icons/lainnya.svg',
    type: CategoryType.expense,
    isDefault: true,
  ),
];

const List<Category> kDefaultIncomeCategories = [
  Category(
    id: 'gaji',
    name: 'Gaji Pokok',
    iconAsset: 'assets/icons/tagihan.svg',
    type: CategoryType.income,
    isDefault: true,
  ),
  Category(
    id: 'freelance',
    name: 'Freelance & Side Job',
    iconAsset: 'assets/icons/belanja.svg',
    type: CategoryType.income,
    isDefault: true,
  ),
  Category(
    id: 'investasi',
    name: 'Investasi & Dividen',
    iconAsset: 'assets/icons/lainnya.svg',
    type: CategoryType.income,
    isDefault: true,
  ),
  Category(
    id: 'bonus',
    name: 'Bonus & Hadiah',
    iconAsset: 'assets/icons/hiburan.svg',
    type: CategoryType.income,
    isDefault: true,
  ),
];
