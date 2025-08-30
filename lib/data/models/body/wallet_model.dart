class WalletBody {
  final int? id;
  final String walletName;
  final String? mnemonic;
  final String? chainNetwork;
  final int isSelected;
  String walletBalance;

  WalletBody({
    this.id,
    required this.walletName,
    this.mnemonic,
    this.isSelected = 1,
    this.chainNetwork,
    this.walletBalance = "0.0",
  });

  factory WalletBody.fromMap(Map<String, dynamic> map) {
    return WalletBody(
      id: map['id'] as int?,
      walletName: map['walletName'] as String,
      mnemonic: map['mnemonic'] as String?,
      isSelected: map['isSelected'] as int,
      chainNetwork: map['chainNetwork'] as String?,
      walletBalance: map['walletBalance'] as String? ?? "0.0",
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'walletName': walletName,
      'chainNetwork': chainNetwork,
      'mnemonic': mnemonic,
      'isSelected': isSelected,
      'walletBalance': walletBalance,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
