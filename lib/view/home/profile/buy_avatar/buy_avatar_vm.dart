import 'dart:async';
import 'dart:developer';
import 'package:aseedak/data/repo/user_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:aseedak/main.dart';
import 'package:aseedak/widgets/custom_snack.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/models/responses/my_api_response.dart';

class Avatar {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final bool isUnlocked;
  final bool isPaid;
  bool isPurchased;
  final bool isDefault;

  Avatar({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isUnlocked,
    required this.isPaid,
    required this.isPurchased,
    required this.isDefault,
  });
}

class BuyAvatarVm extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  static const String kAvatarProductId = 'buy_avatar'; // Single product ID

  bool _available = false;
  bool get isAvailable => _available;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Avatar> _avatars = [];
  List<Avatar> get avatars => _avatars;

  Avatar? _pendingAvatar;
  final UserRepo userRepo = GetIt.I<UserRepo>();

  BuyAvatarVm() {
    _init();
  }

  Future<void> _init() async {
    await getAvatars();

    // if (kDebugMode) {
    //   _available = true;
    //   _isLoading = false;
    //   notifyListeners();
    //   return;
    // }

    _available = await _inAppPurchase.isAvailable();
    if (!_available) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _subscription = _inAppPurchase.purchaseStream.listen(_onPurchaseUpdated);
    _isLoading = false;
    notifyListeners();
  }

  bool canUse(Avatar avatar) {
    return avatar.isUnlocked || avatar.isDefault || avatar.isPurchased;
  }

  Future<void> buyAvatar(Avatar avatar) async {
    // if (kDebugMode) {
    //   await _handleAvatarPurchaseSuccess(avatar);
    //   return;
    // }

    if (!_available) {
      customSnack(
        text: "store_not_available".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
      return;
    }

    final response = await _inAppPurchase.queryProductDetails({kAvatarProductId});
    if (response.productDetails.isEmpty) {
      customSnack(
        text: "product_not_found".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
      return;
    }

    final product = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: product);

    _pendingAvatar = avatar;
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (_pendingAvatar != null) {
          _handleAvatarPurchaseSuccess(_pendingAvatar!);
        }

        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }
      }
    }
  }

  /// ✅ Handle success locally + send to backend
  Future<void> _handleAvatarPurchaseSuccess(Avatar avatar) async {
    avatar.isPurchased = true;
    notifyListeners();

    // Show local success
    customSnack(
      text: "purchase_success".tr(),
      context: navigatorKey.currentContext!,
      isSuccess: true,
    );

    // 🔥 Call backend to update user data
    try {
      ApiResponse apiResponse = await userRepo.updateUser(
        "characters",
        [avatar.id], // Matches required payload: "characters": ["{{character_id}}"]
      );

      if (apiResponse.response != null &&
          (apiResponse.response!.statusCode == 200 ||
              apiResponse.response!.statusCode == 201)) {
        log("User data updated successfully after purchase for avatar: ${avatar.id}");
        customSnack(
          context: navigatorKey.currentContext!,
          text: "Congratulations! You have successfully purchased ${avatar.name}.",
          isSuccess: true,
        );
      } else {
        log("Failed to update user data after purchase.");
      }
    } catch (e) {
      log("Error updating user after purchase: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> getAvatars() async {
    try {
      _isLoading = true;
      notifyListeners();

      ApiResponse apiResponse = await userRepo.getAvatars();

      if (apiResponse.response != null &&
          (apiResponse.response!.statusCode == 200 ||
              apiResponse.response!.statusCode == 201)) {
        final List<dynamic> characters = apiResponse.response!.data['characters'];

        _avatars = characters
            .map(
              (e) => Avatar(
            id: e['id'] ?? '',
            name: e['name'] ?? '',
            description: e['description'] ?? '',
            imageUrl: e['imageUrl'] ?? '',
            price: (e['price'] != null)
                ? double.tryParse(e['price'].toString()) ?? 0
                : 0,
            isUnlocked: e['isUnlocked'] ?? false,
            isPaid: e['isPaid'] ?? true,
            isPurchased: e['isPurchased'] ?? false,
            isDefault: e['isDefault'] ?? false,
          ),
        )
            .toList();
      } else {
        _avatars = [];
      }
    } catch (e) {
      _avatars = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
