import 'dart:async';
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
  final bool isUnlocked;  // Free to use
  final bool isPaid;      // Requires purchase
  bool isPurchased;       // User has purchased
  final bool isDefault;   // Default avatar

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

  bool _available = false;
  bool get isAvailable => _available;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Avatar> _avatars = [];
  List<Avatar> get avatars => _avatars;

  BuyAvatarVm() {
    _init();
  }

  Future<void> _init() async {
    await getAvatars();
    if (kDebugMode) {
      // _loadMockData();
      _available = true;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _available = await _inAppPurchase.isAvailable();
    if (!_available) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _subscription = _inAppPurchase.purchaseStream.listen(_onPurchaseUpdated);
    await fetchAvatarsFromServer();
    _isLoading = false;
    notifyListeners();
  }


  Future<void> fetchAvatarsFromServer() async {
    // TODO: Replace with your API call to get avatars
    await Future.delayed(const Duration(seconds: 1));
  }

  bool canUse(Avatar avatar) {
    return avatar.isUnlocked || avatar.isDefault || avatar.isPurchased;
  }

  Future<void> buyAvatar(Avatar avatar) async {
    if (kDebugMode) {
      avatar.isPurchased = true;
      notifyListeners();
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

    final response = await _inAppPurchase.queryProductDetails({avatar.id});
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
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        try {
          final avatar = _avatars.firstWhere((a) => a.id == purchase.productID);
          avatar.isPurchased = true;
          notifyListeners();

          customSnack(
            text: "purchase_success".tr(),
            context: navigatorKey.currentContext!,
            isSuccess: true,
          );

          if (purchase.pendingCompletePurchase) {
            _inAppPurchase.completePurchase(purchase);
          }
        } catch (_) {
          // avatar not found, ignore
        }
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  UserRepo userRepo = GetIt.I.get<UserRepo>();




  Future<void> getAvatars() async {
    try {
      _isLoading = true;
      notifyListeners();

      ApiResponse apiResponse = await userRepo.getAvatars();

      if (apiResponse.response != null &&
          (apiResponse.response!.statusCode == 200 ||
              apiResponse.response!.statusCode == 201)) {
        final List<dynamic> characters = apiResponse.response!.data['characters'];

        _avatars = characters.map((e) => Avatar(
          id: e['id'] ?? '',
          name: e['name'] ?? '',
          description: e['description'] ?? '',
          imageUrl: e['imageUrl'] ?? '',
          price: (e['price'] != null) ? double.tryParse(e['price'].toString()) ?? 0 : 0,
          isUnlocked: e['isUnlocked'] ?? false,
          isPaid: e['isPaid'] ?? true,
          isPurchased: e['isPurchased'] ?? false,
          isDefault: e['isDefault'] ?? false,
        )).toList();
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
