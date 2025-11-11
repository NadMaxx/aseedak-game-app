import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aseedak/main.dart';
import 'package:aseedak/widgets/custom_snack.dart';
import '../../../../data/models/responses/my_api_response.dart';
import '../../../../data/repo/user_repo.dart';

class Word {
  final String id;
  final String word1;
  final String word2;
  final String word3;

  Word({
    required this.id,
    required this.word1,
    required this.word2,
    required this.word3,
  });
}

class WordDeck {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isActive;
  final List<Word> words;
  bool isPurchased;

  WordDeck({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isActive,
    required this.words,
    this.isPurchased = false,
  });
}
class WordDeckUser {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isActive;
  bool isPurchased;

  WordDeckUser({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isActive,
    this.isPurchased = false,
  });
}

class BuyWordDeckVm extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final UserRepo userRepo = GetIt.I.get<UserRepo>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<WordDeck> _decks = [];
  List<WordDeck> get decks => _decks;

  BuyWordDeckVm() {
   init();
  }
  init()async{
   await fetchUserDecks();
    getWordDecks();
  }

  Future<void> getWordDecks() async {
    try {
      _isLoading = true;
      notifyListeners();

      ApiResponse apiResponse = await userRepo.getWordDecks();
      if (apiResponse.response != null &&
          (apiResponse.response!.statusCode == 200 ||
              apiResponse.response!.statusCode == 201)) {
        final List<dynamic> data = apiResponse.response!.data['wordDecks'];
        _decks = data.map((deck) {
          List<Word> words = (deck['words'] as List<dynamic>).map((w) {
            return Word(
              id: w['id'],
              word1: w['word1'],
              word2: w['word2'],
              word3: w['word3'],
            );
          }).toList();

          return WordDeck(
            id: deck['id'],
            name: deck['name'],
            description: deck['description'],
            price: (deck['price'] ?? 0).toDouble(),
            isActive: deck['isActive'] ?? false,
            words: words,
            isPurchased: false, // initially false
          );
        }).toList();

        // ✅ Mark decks as purchased if user already owns them
        for (var deck in _decks) {
          if (_decksUser.any((userDeck) => userDeck.id == deck.id && userDeck.isPurchased)) {
            log("Marking deck as purchased: ${deck.id}");
            deck.isPurchased = true;
          }
        }
      }
    } catch (e) {
      _decks = [];
      log("Error fetching word decks: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Purchase a deck
  Future<void> buyDeck(WordDeck deck) async {
    log("Initiating purchase for deck: ${deck.id}");
    if (kDebugMode) {
      deck.isPurchased = true;
      notifyListeners();
      customSnack(
        text: "deck_purchase_success".tr(),
        context: navigatorKey.currentContext!,
        isSuccess: true,
      );
      await updateUserWithDeck(deck.id);
      return;
    }

    final response = await _inAppPurchase.queryProductDetails({'buy_word_deck'});
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

  /// ✅ Update user after successful deck purchase
  Future<void> updateUserWithDeck(String deckId) async {
    try {
      ApiResponse apiResponse = await userRepo.updateUser(
        "wordDecks",
        [deckId], // {"wordDecks": ["deckId"]}
      );

      if (apiResponse.response != null &&
          (apiResponse.response!.statusCode == 200 ||
              apiResponse.response!.statusCode == 201)) {
        log("User updated successfully with deck: $deckId");
        customSnack(
          text: "deck_purchase_success".tr(),
          context: navigatorKey.currentContext!,
          isSuccess: true,
        );
      } else {
        log("Failed to update user with deck: $deckId");
      }
    } catch (e) {
      log("Error updating user with deck: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  List<WordDeckUser> _decksUser = [];
  List<WordDeckUser> get decksUser => _decksUser;

  Future<void> fetchUserDecks() async {
    try {
      _isLoading = true;
      notifyListeners();

      ApiResponse apiResponse = await userRepo.getUserDecks(); // New endpoint
      if (apiResponse.response != null &&
          (apiResponse.response!.statusCode == 200 ||
              apiResponse.response!.statusCode == 201)) {

        final List<dynamic> userDecks = apiResponse.response!.data['decks'];

        // Clear previous list
        _decksUser.clear();

        _decksUser = userDecks.map((userDeck) {
          return WordDeckUser(
            id: userDeck['id'] ?? '',
            name: userDeck['name'] ?? '',
            description: userDeck['description'] ?? '',
            price: (userDeck['price'] ?? 0).toDouble(),
            isActive: userDeck['isActive'] ?? false,
            isPurchased: userDeck['isPurchased'] ?? false,
          );
        }).toList();
      }
    } catch (e) {
      log("Error fetching user decks: $e");
      _decksUser = [];
    }

    _isLoading = false;
    notifyListeners();
  }

}
