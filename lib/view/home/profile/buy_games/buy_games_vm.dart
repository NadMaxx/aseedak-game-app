import 'dart:async';
import 'dart:developer';
import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/user_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/widgets/custom_snack.dart';
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/main.dart';

class BuyGamesVm extends BaseVm {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _available = false;
  bool get isAvailable => _available;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  // Your actual product IDs from the stores
  static const Set<String> _productIds = {
    'buy_5_games',
    'buy_10_games',
    'buy_25_games',
  };

  BuyGamesVm() {
    _initStore();
  }

  // ------------------ INIT STORE -----------------------
  Future<void> _initStore() async {
    _isLoading = true;
    notifyListeners();

    // ✅ If in debug mode, skip real store and use mock data
    if (kDebugMode) {
      log("⚙️ Debug mode detected — using mock product data");
      _loadMockProducts();
      _isLoading = false;
      _available = true;
      notifyListeners();
      return;
    }

    _available = await _inAppPurchase.isAvailable();
    if (!_available) {
      log("In-app purchases not available");
      _isLoading = false;
      notifyListeners();
      return;
    }

    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        log("Purchase stream error: $error");
        customSnack(
          text: "purchase_failed".tr(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
      },
    );

    final response = await _inAppPurchase.queryProductDetails(_productIds);
    if (response.error != null) {
      log("Error fetching products: ${response.error}");
      _isLoading = false;
      notifyListeners();
      return;
    }

    _products = response.productDetails;
    log("✅ Products loaded: ${_products.map((e) => e.id).toList()}");

    _isLoading = false;
    notifyListeners();
  }

  // ------------------ MOCK DATA -----------------------
  void _loadMockProducts() {
    _products = [
      ProductDetails(
        id: 'buy_5_games',
        title: 'Starter Pack — 5 Extra Games',
        description: 'Perfect for trying more rounds',
        price: '\$3.00',
        rawPrice: 3.0,
        currencyCode: 'USD',
      ),
      ProductDetails(
        id: 'buy_10_games',
        title: 'Gamer Pack — 10 Extra Games',
        description: 'Double your fun instantly',
        price: '\$5.00',
        rawPrice: 5.0,
        currencyCode: 'USD',
      ),
      ProductDetails(
        id: 'buy_25_games',
        title: 'Ultimate Pack — 25 Extra Games',
        description: 'Unlimited excitement unlocked',
        price: '\$10.00',
        rawPrice: 10.0,
        currencyCode: 'USD',
      ),
    ];
  }

  // ------------------ PURCHASE FLOW -----------------------
  Future<void> buyProduct(ProductDetails product) async {
    if (kDebugMode) {
      // ✅ Mock purchase success for debug testing
      log("🧪 Mock purchase for ${product.id}");
      customSnack(
        text: "purchase_success".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: true,
      );
      return;
    }

    if (!_available) {
      customSnack(
        text: "store_not_available".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _handlePurchaseSuccess(purchase);
          break;
        case PurchaseStatus.error:
          customSnack(
            text: "purchase_failed".tr(),
            context: navigatorKey.currentContext!,
            isSuccess: false,
          );
          break;
        default:
          break;
      }

      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  Future<void> _handlePurchaseSuccess(PurchaseDetails purchase) async {
    log("✅ Purchase success: ${purchase.productID}");
    customSnack(
      text: "purchase_success".tr(),
      context: navigatorKey.currentContext!,
      isSuccess: true,
    );

    if (purchase.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchase);
    }
    int gamesPurchased = 0;
    switch (purchase.productID) {
      case 'buy_5_games':
        gamesPurchased = 5;
        break;
      case 'buy_10_games':
        gamesPurchased = 10;
        break;
      case 'buy_25_games':
        gamesPurchased = 25;
        break;
    }
    if (gamesPurchased > 0) {
      await updateUserData(gamesPurchased);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  UserRepo get userRepo => GetIt.I<UserRepo>();

  updateUserData(int games) async {
    ApiResponse apiResponse = await userRepo.updateUser("newGamesPurchased", games);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200 || apiResponse.response!.statusCode == 201) {
      log("User data updated successfully after purchase");
      customSnack(context: navigatorKey.currentContext!, text: "Congratulations you have successfully purchased $games games.", isSuccess: true);

    }
  }
}
