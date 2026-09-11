enum WalletType {
  cash,
  ewallet,
  bank;

  String get label {
    switch (this) {
      case WalletType.cash:
        return 'Uang Tunai';
      case WalletType.ewallet:
        return 'E-Wallet';
      case WalletType.bank:
        return 'Rekening Bank';
    }
  }

  static WalletType fromString(String val) {
    switch (val.toLowerCase()) {
      case 'cash':
      case 'tunai':
        return WalletType.cash;
      case 'ewallet':
      case 'e-wallet':
        return WalletType.ewallet;
      case 'bank':
      case 'rekening':
      default:
        return WalletType.bank;
    }
  }
}

class Wallet {
  const Wallet({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.balance,
  });

  final String id;
  final String userId;
  final String name;
  final WalletType type;
  final int balance;

  Wallet copyWith({
    String? id,
    String? userId,
    String? name,
    WalletType? type,
    int? balance,
  }) {
    return Wallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wallet &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          name == other.name &&
          type == other.type &&
          balance == other.balance;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      type.hashCode ^
      balance.hashCode;
}
