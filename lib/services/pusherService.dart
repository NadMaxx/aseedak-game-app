import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class RealtimeService {
  final String pusherKey;
  final String pusherCluster;
  final String userId;

  late final PusherChannelsFlutter _pusher;

  RealtimeService({
    required this.pusherKey,
    required this.pusherCluster,
    required this.userId,
  });

  Future<void> connect() async {
    _pusher = PusherChannelsFlutter.getInstance();
    await _pusher.init(
      apiKey: "d440ce92ce74e8791deb",
      cluster: "mt1",
      onEvent: (PusherEvent event) {
        if (kDebugMode) {
          print('Pusher event: ${event.channelName} ${event.eventName} ${event.data}');
        }
      },
      onConnectionStateChange: (String currentState, String? previousState) {
        if (kDebugMode) print('Pusher state: $previousState -> $currentState');
      },
      onError: (String message, int? code, dynamic exception) {
        if (kDebugMode) print('Pusher error: $message ($code)');
      },
    );

    await _pusher.connect();
    await subscribeUserChannel(userId);
  }

  Future<void> subscribeUserChannel(String userId) async {
    final channelName = 'user-$userId';
    await _pusher.subscribe(channelName: channelName);
    // _pusher.onEvent
  }

  Future<void> subscribeEvent(String chatRoomId, {
    void Function(Map<String, dynamic> payload)? onNewMessage,
    void Function(Map<String, dynamic> payload)? onTyping,
    void Function(Map<String, dynamic> payload)? onMessageRead,
  }) async {
    try{
      log("Subscribing to chat room: $chatRoomId");
      final channelName  = chatRoomId;
      await _pusher.subscribe(channelName: channelName).then((v){
        if (kDebugMode) {
          log('Subscribed to channel: $channelName');
        }
      });

      _pusher.onEvent = (PusherEvent event) {
        if (event.channelName == channelName && event.eventName == 'new-message') {
          final data = _safeJson(event.data);
          if (onNewMessage != null) {
            onNewMessage(data); // use ! since it's nullable
          }
        }
      };


    }catch(e){
      log("Error subscribing to chat room $chatRoomId: $e");
    }

  }

  Future<void> unsubscribeChat(String chatRoomId) async {
    await _pusher.unsubscribe(channelName: 'chat-$chatRoomId');
  }

  Future<void> disconnect() async {
    await _pusher.disconnect();
  }

  Map<String, dynamic> _safeJson(String? raw) {
    try {
      if (raw == null || raw.isEmpty) return {};
      return json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}