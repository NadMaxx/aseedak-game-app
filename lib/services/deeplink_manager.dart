import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../widgets/custom_loader.dart';

class DeepLinkManager extends ChangeNotifier {
  static DeepLinkManager? _instance;
  AppLinks? _appLinks;
  String? _pendingDeepLink;
  bool _isInitialized = false;

  static DeepLinkManager get instance {
    _instance ??= DeepLinkManager._();
    return _instance!;
  }

  DeepLinkManager._();

  // Check and store initial link (call this early in app startup)
  Future<void> checkInitialLink() async {
    if (_isInitialized) return;

    _appLinks = AppLinks();
    final prefs = await SharedPreferences.getInstance();

    final Uri? initialUri = await _appLinks?.getInitialLink();

    if (initialUri != null) {
      final currentLink = initialUri.toString();
      final lastHandled = prefs.getString('last_handled_link');

      if (lastHandled != currentLink) {
        _pendingDeepLink = currentLink;
        await prefs.setString('last_handled_link', currentLink);
        log("Stored pending deep link: $_pendingDeepLink");
      }
    }

    _isInitialized = true;
  }

  // Start listening for new deep links (call after APIs)
  void startListening() {
    _appLinks?.uriLinkStream.listen((Uri uri) async {
      log("New deep link received: ${uri.toString()}");
      await _handleDeepLink(uri.toString());
    });
  }

  // Handle pending deep link (call after APIs complete)
  Future<void> handlePendingLink() async {
    if (_pendingDeepLink != null) {
      final link = _pendingDeepLink!;
      _pendingDeepLink = null; // Clear it immediately

      log("Processing pending deep link: $link");
      await _handleDeepLink(link);
    }
  }

  Function(String gameCode)? _onJoinRoom;

  // Set the callback when dashboard initializes
  void setJoinRoomCallback(Function(String gameCode) callback) {
    _onJoinRoom = callback;
  }
  void clearCallback() {
    _onJoinRoom = null;
  }

  Future<void> _handleDeepLink(String link) async {
    final uri = Uri.parse(link);

    if (uri.host == 'profile') {
      final gameCode = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
      if (gameCode == null) return;

      log("Navigating to Profile with ID: $gameCode");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Show loader before API call
        showDialog(
          context: navigatorKey.currentState!.context,
          builder: (ctx) => CustomLoader(),
        );

        if (_onJoinRoom != null) {
          await _onJoinRoom!(gameCode);
        }
      });
      // Call the callback

    }
  }
  void dispose() {
    _pendingDeepLink = null;
    super.dispose();
  }
}