import 'dart:async';
import 'dart:developer';
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
  final String _productId = 'extra_players';

  DashboardVm() {
    _initializeDashboard();
    initStoreInfo();
  }

  // ------------------ INIT STORE -----------------------
  Future<void> initStoreInfo() async {
    _available = await _inAppPurchase.isAvailable();
    if (!_available) {
      log("In-app purchase not available");
      return;
    }

    // Listen for purchase updates
    _subscription = _inAppPurchase.purchaseStream.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription?.cancel(),
      onError: (error) => log("Purchase stream error: $error"),
    );

    const Set<String> ids = {'extra_players'};
    final ProductDetailsResponse response =
    await _inAppPurchase.queryProductDetails(ids);

    if (response.error != null) {
      log("Product query error: ${response.error}");
      return;
    }

    if (response.notFoundIDs.isNotEmpty) {
      log("Product not found: ${response.notFoundIDs}");
      return;
    }

    _products = response.productDetails;
    log("Products loaded: ${_products.length}");
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _handlePurchaseSuccess(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        log("Purchase error: ${purchase.error}");
        customSnack(
          text: "Purchase failed".tr(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
      }
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  Future<void> _handlePurchaseSuccess(PurchaseDetails purchase) async {
    log("Purchase successful: ${purchase.productID}");

    // Extract the server verification token
    final token = purchase.verificationData.serverVerificationData;

    // Send it to your backend for validation and unlocking
    // await userRepo.verifyPurchaseOnServer(
    //   productId: purchase.productID,
    //   purchaseToken: token,
    //   purchaseId: purchase.purchaseID ?? '',
    //   transactionDate: purchase.transactionDate,
    // );

    // Then show success
    customSnack(
      text: "purchase_success".tr(),
      context: navigatorKey.currentContext!,
      isSuccess: true,
    );

    // Complete the transaction
    if (purchase.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchase);
    }
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
        if (int.parse(playerController.text.trim()) > 4) {
          showBuyPlayerSheet();
          return;
        }
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
    final product =
    _products.isNotEmpty ? _products.firstWhere((p) => p.id == _productId) : null;

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
        text: "No product found".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );
      return;
    }

    final product = _products.firstWhere((p) => p.id == _productId);
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
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
            : ui.TextDirection.ltr, child: SingleChildScrollView(child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery
            .of(navigatorKey.currentContext!,)
            .viewInsets
            .bottom,), child: Form(
        key: formKey, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [ Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomText(
          text: "join_room_code_label".tr(),
          fontFamily: "Kanit",
          fontWeight: FontWeight.w500,
          fontSize: 18.sp,),
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
          },),
      ],),), SizedBox(height: 10.h), Divider(),
      ],),),),),), onConfirmPressed: () async {
      if (!formKey.currentState!.validate()) return;
      Navigator.pop(navigatorKey.currentContext!);
      showLoaderDialog();
      await joinRoom(roomCodeController.text.trim());
    },);
  }
}
