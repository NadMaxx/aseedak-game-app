import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:ui' as ui;

import 'package:app_links/app_links.dart';
import 'package:aseedak/data/models/body/CreateRoomBody.dart';
import 'package:aseedak/data/models/responses/ProgressRooms.dart';
import 'package:aseedak/data/models/responses/UserModel.dart';
import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/data/repo/user_repo.dart';
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/main.dart';
import 'package:aseedak/view/home/game_room/game_room.dart';
import 'package:aseedak/view/home/profile/profile_settings/profile_settings.dart';
import 'package:aseedak/view/home/wait_room/wait_room.dart';
import 'package:aseedak/widgets/customCirle.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_loader.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/base_vm.dart';
import '../../../data/models/responses/RoomCreatedResponse.dart';
import '../../../services/deeplink_manager.dart';
import '../../../widgets/customTextField.dart';
import '../../../widgets/custom_snack.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DashboardVm extends BaseVm {
  final UserRepo userRepo = GetIt.I.get<UserRepo>();
  final AuthRepo authRepo = GetIt.I.get<AuthRepo>();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _available = false;
  List<ProductDetails> _products = [];
  final String _productId = 'extra_player';

  DashboardVm() {
    _initializeDashboard();
    initStoreInfo();
  }

  // ------------------ INIT STORE -----------------------
  Future<void> initStoreInfo() async {
    try {
      _available = await _inAppPurchase.isAvailable();
      if (!_available) {
        log("In-app purchase not available");
        return;
      }

      // Listen for purchase updates
      _subscription = _inAppPurchase.purchaseStream.listen(
        _listenToPurchaseUpdated,
        onDone: () {
          log("Purchase stream completed");
          _subscription?.cancel();
        },
        onError: (error) {
          log("Purchase stream error: $error");
        },
      );

      // Query product details
      const Set<String> ids = {'extra_player'};
      final ProductDetailsResponse response =
      await _inAppPurchase.queryProductDetails(ids);

      if (response.error != null) {
        log("Product query error: ${response.error}");
        return;
      }

      if (response.notFoundIDs.isNotEmpty) {
        log("Product not found: ${response.notFoundIDs}");
        log("Make sure 'extra_player' exists in App Store Connect");
        return;
      }

      _products = response.productDetails;
      log("Products loaded: ${_products.length}");

      // For iOS, restore previous purchases
      if (Platform.isIOS) {
        await _inAppPurchase.restorePurchases();
      }
    } catch (e) {
      log("Error initializing store: $e");
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      log("Purchase status: ${purchase.status} for ${purchase.productID}");

      if (purchase.status == PurchaseStatus.pending) {
        log("Purchase pending...");
        // Show loading indicator if needed
      } else if (purchase.status == PurchaseStatus.purchased) {
        await _handlePurchaseSuccess(purchase);
      } else if (purchase.status == PurchaseStatus.restored) {
        await _handlePurchaseRestored(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        log("Purchase error: ${purchase.error}");
        customSnack(
          text: purchase.error?.message ?? "Purchase failed".tr(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
      } else if (purchase.status == PurchaseStatus.canceled) {
        log("Purchase canceled by user");
        customSnack(
          text: "Purchase canceled".tr(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
      }

      // CRITICAL: Always complete the purchase for iOS
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
        log("Purchase completed: ${purchase.productID}");
      }
    }
  }

  Future<void> _handlePurchaseSuccess(PurchaseDetails purchase) async {
    log("Purchase successful: ${purchase.productID}");

    try {
      // Extract verification data - different for iOS and Android
      String token;
      if (Platform.isIOS) {
        // For iOS, this is the App Store receipt
        token = purchase.verificationData.serverVerificationData;
        log("iOS receipt data length: ${token.length}");
      } else {
        // For Android, this is the purchase token
        token = purchase.verificationData.serverVerificationData;
        log("Android purchase token length: ${token.length}");
      }

      // Send to backend for verification
      await updatePlayersMaxToServer(token, 3);

      customSnack(
        text: "purchase_success".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: true,
      );
    } catch (e) {
      log("Error handling purchase: $e");
      customSnack(
        text: "Error processing purchase".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
    }
  }

  Future<void> _handlePurchaseRestored(PurchaseDetails purchase) async {
    log("Purchase restored: ${purchase.productID}");
    // Handle restored purchase (same as success for consumables)
    await _handlePurchaseSuccess(purchase);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    DeepLinkManager.instance.clearCallback();
    super.dispose();
  }

  // ------------------ DASHBOARD INIT -----------------------
  Future<void> _initializeDashboard() async {
    await getInProgressRooms();

    DeepLinkManager.instance.setJoinRoomCallback((gameCode) async {
      await joinRoom(gameCode);
    });

    DeepLinkManager.instance.startListening();
    await DeepLinkManager.instance.handlePendingLink();
  }

  // ------------------ CREATE ROOM -----------------------
  void showCreateRoomSheet() {
    TextEditingController roomController = TextEditingController();
    TextEditingController playerController = TextEditingController(text: "2");

    if (kDebugMode) {
      roomController.text = "Test Room";
    }

    final formKey = GlobalKey<FormState>();

    showCustomSheetWithContent(
      children: Directionality(
        textDirection: navigatorKey.currentContext!.locale.languageCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(navigatorKey.currentContext!)
                  .viewInsets
                  .bottom,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "create_room_title".tr(),
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),
                        CustomTextField(
                          controller: roomController,
                          prefix: "kamra",
                          hintText: "create_room_hint".tr(),
                          keyboardType: TextInputType.text,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "create_room_required".tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                        CustomText(
                          text: "create_room_select_players".tr(),
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),
                        CustomTextField(
                          controller: playerController,
                          prefix: "bandy",
                          hintText: "create_room_players_hint".tr(),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "create_room_players_required".tr();
                            }
                            final num? players = int.tryParse(v);
                            if (players == null) {
                              return "create_room_players_invalid".tr();
                            }
                            if (players < 2) {
                              return "create_room_players_min".tr();
                            }
                            if (players > 8) {
                              return "player_error".tr();
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
      onConfirmPressed: () async {
        if (!formKey.currentState!.validate()) return;
        Navigator.pop(navigatorKey.currentContext!);
        showLoaderDialog();

        CreateRoomBody createRoomBody = CreateRoomBody(
          category: "all",
          name: roomController.text.trim(),
          maxPlayers: int.parse(playerController.text.trim()),
          difficulty: "medium",
          timeLimit: 300,
          invitedUsers: ["68d5780e7c37125af123beba"],
        );
        await createRoom(createRoomBody);
      },
    );
  }

  // ------------------ BUY PLAYERS -----------------------
  void showBuyPlayerSheet() {
    ProductDetails? product;

    if (_products.isNotEmpty) {
      try {
        product = _products.firstWhere((p) => p.id == _productId);
      } catch (e) {
        // If product not found, use first available
        product = _products.first;
      }
    }

    showCustomSheetWithContent(
      children: Directionality(
        textDirection: navigatorKey.currentContext!.locale.languageCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "buy_more_players_title".tr(),
                    fontFamily: "Kanit",
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                  SizedBox(height: 10.h),
                  CustomText(
                    text: "buy_more_players_subtitle".tr(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Kanit",
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            const Divider(),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  SvgPicture.asset("person".toSvgPath),
                  SizedBox(width: 10.w),
                  CustomText(
                    text: "buy_more_players_4_players".tr(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Kanit",
                  ),
                  const Spacer(),
                  CustomText(
                    text: product?.price ?? "\$5.00",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Kanit",
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            const Divider(),
          ],
        ),
      ),
      onConfirmPressed: () async {
        Navigator.pop(navigatorKey.currentContext!);
        await buyExtraPlayers();
      },
      confirmText: "buy_now".tr(),
    );
  }

  Future<void> buyExtraPlayers() async {
    if (!_available) {
      customSnack(
        text: "Store not available".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
      return;
    }

    if (_products.isEmpty) {
      customSnack(
        text: "No product found. Please try again.".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
      return;
    }

    try {
      // Find the product without using orElse
      ProductDetails? product;
      for (var p in _products) {
        if (p.id == _productId) {
          product = p;
          break;
        }
      }

      // If exact product not found, use first available
      product ??= _products.first;

      log("Initiating purchase for: ${product.id}");

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: null, // Optional: Add user identifier
      );

      // IMPORTANT: Use buyNonConsumable for non-consumable products (permanent unlocks)
      // Use buyConsumable for consumable products (can be purchased multiple times)
      final bool purchaseResult = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!purchaseResult) {
        log("Purchase initiation failed");
        customSnack(
          text: "Failed to start purchase".tr(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
      } else {
        log("Purchase initiated successfully");
      }
    } catch (e) {
      log("Error initiating purchase: $e");
      customSnack(
        text: "Error: ${e.toString()}",
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
    }
  }

  // ------------------ OTHER METHODS -----------------------
  void showLoaderDialog() {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (ctx) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          height: 200.h,
          width: AppConstants.getScreenWidth(ctx) * 0.8,
          child: const CupertinoActivityIndicator(color: Colors.white),
        ),
      ),
    );
  }

  bool _isLoading = false;

  Future<void> createRoom(CreateRoomBody body) async {
    ApiResponse apiResponse = await userRepo.createGameRoom(body: body);
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      AppConstants.roomData =
          RoomCreatedResponse.fromJson(apiResponse.response?.data);
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pushNamed(navigatorKey.currentContext!, WaitingRoom.routeName,
          arguments: AppConstants.roomData.room!.code);
      _isLoading = false;
      notifyListeners();
    } else {
      Navigator.pop(navigatorKey.currentContext!);
      if (apiResponse.error.toString().toLowerCase().contains("upgrade")) {
        showBuyPlayerSheet();
        return;
      }
      customSnack(
        text: apiResponse.error!.toString(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> joinRoom(String roomCode) async {
    ApiResponse apiResponse = await userRepo.joinGameRoom(roomCode: roomCode);
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      AppConstants.roomData =
          RoomCreatedResponse.fromJson(apiResponse.response?.data);
      Navigator.pop(navigatorKey.currentContext!);
      if (AppConstants.roomData.room != null &&
          AppConstants.roomData.room!.status == "IN_PROGRESS") {
        customSnack(
          text: "Room is already in progress".tr(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
        return;
      }
      Navigator.pushNamed(navigatorKey.currentContext!, WaitingRoom.routeName,
          arguments: AppConstants.roomData.room!.code);
      _isLoading = false;
      notifyListeners();
    } else {
      Navigator.pop(navigatorKey.currentContext!);
      customSnack(
        text: apiResponse.error!.toString(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getInProgressRooms() async {
    ApiResponse apiResponse = await userRepo.inProgressRooms();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      ProgressRooms progressRooms =
      ProgressRooms.fromJson(apiResponse.response?.data);
      if (progressRooms.rooms == null || progressRooms.rooms!.isEmpty) {
        return;
      }
      Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentState!.context,
        GameRoom.routeName,
        arguments: progressRooms.rooms!.first.code!,
            (R) => false,
      );
      notifyListeners();
    } else {
      customSnack(
        text: apiResponse.error!.toString(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  showJoinRoomSheet() {
    TextEditingController roomCodeController = TextEditingController();
    if (kDebugMode) {
      roomCodeController.text = "9F67D77C";
    }
    final formKey = GlobalKey<FormState>();
    showCustomSheetWithContent(
      children: Directionality(
        textDirection: navigatorKey.currentContext!.locale.languageCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(navigatorKey.currentContext!)
                  .viewInsets
                  .bottom,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "join_room_code_label".tr(),
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),
                        CustomTextField(
                          controller: roomCodeController,
                          prefix: "kamra",
                          hintText: "join_room_code_hint".tr(),
                          keyboardType: TextInputType.text,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "join_room_code_required".tr();
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
      onConfirmPressed: () async {
        if (!formKey.currentState!.validate()) return;
        Navigator.pop(navigatorKey.currentContext!);
        showLoaderDialog();
        await joinRoom(roomCodeController.text.trim());
      },
    );
  }

  updatePlayersMaxToServer(String paymentId, dynamic amount) async {
    updateUserData();
    ApiResponse apiResponse = await userRepo.updateMaxPlayers(
      paymentIntendId: paymentId,
      amount: amount,
    );
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      customSnack(
        text: "Max players updated successfully".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: true,
      );
    }
  }

  updateUserData() async {
    ApiResponse apiResponse = await userRepo.updateUser("maxMembers", 8);
  }
}