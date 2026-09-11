enum CategoryType { income, expense }

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.iconAsset,
    this.type = CategoryType.expense,
    this.isDefault = false,
  });

  final String id;
  final String name;
  final String iconAsset;
  final CategoryType type;
  final bool isDefault;

  Category copyWith({
    String? id,
    String? name,
    String? iconAsset,
    CategoryType? type,
    bool? isDefault,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconAsset: iconAsset ?? this.iconAsset,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          iconAsset == other.iconAsset &&
          type == other.type &&
          isDefault == other.isDefault;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      iconAsset.hashCode ^
      type.hashCode ^
      isDefault.hashCode;
}
