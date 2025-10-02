import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class RealtimeService {
  final String pusherKey;
  final String pusherCluster;

  late final PusherChannelsFlutter _pusher;

  RealtimeService({
    required this.pusherKey,
    required this.pusherCluster,
  });

  Future<void> connect() async {
    _pusher = PusherChannelsFlutter.getInstance();
    await _pusher.init(
      apiKey: "d440ce92ce74e8791deb",
      cluster: "mt1",
      onEvent: (PusherEvent event) {
        if (kDebugMode) {
          log('Pusher event: ${event.channelName} ${event.eventName} ${event.data}');
        }
      },
      onConnectionStateChange: (String currentState, String? previousState) {
        if (kDebugMode) log('Pusher state: $previousState -> $currentState');
      },
      onError: (String message, int? code, dynamic exception) {
        if (kDebugMode) log('Pusher error: $message ($code)');
      },
    );

    await _pusher.connect();
  }

  Future<void> subscribeUserChannel(
      String userId,{
        void Function(Map<String, dynamic> payload)? killRequest,
      }
      ) async {
    final channelName = 'user-$userId';
    await _pusher.subscribe(channelName: channelName).then((v){
      if (kDebugMode) {
        log('Subscribed to user channel: $channelName');
      }
    });
    _pusher.onEvent = (PusherEvent event) {
      if (event.eventName == ' elimination-request') {
        log("Event on user channel: ${event.channelName}, ${event.eventName}, ${event.data}");
        log("Kill request received in user channel ${killRequest}" );
        final data = _safeJson(event.data);
        if (killRequest != null) {
          killRequest(data); // use ! since it's nullable
        }
      }
    };
    // _pusher.onEvent
  }

  Future<void> subscribeEvent(String chatRoomId, {
    void Function(Map<String, dynamic> payload)? onGameStart,
    void Function(Map<String, dynamic> payload)? onUserJoin,
    void Function(Map<String, dynamic> payload)? playerLeft,
    void Function(Map<String, dynamic> payload)? killRequest,
    void Function(Map<String, dynamic> payload)? eliminationConfirmed,
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
        log("Event on channel: ${event.channelName}, ${event.eventName}, ${event.data}");
        if (event.channelName == channelName && event.eventName == 'game-started') {
          final data = _safeJson(event.data);
          if (onGameStart != null) {
            onGameStart(data); // use ! since it's nullable
          }
        }
        if( event.channelName == channelName && event.eventName == 'player-joined') {
          final data = _safeJson(event.data);
          if (onUserJoin != null) {
            onUserJoin(data); // use ! since it's nullable
          }
        }
        if( event.channelName == channelName && event.eventName == 'player-left') {
          final data = _safeJson(event.data);
          if (playerLeft != null) {
            playerLeft(data); // use ! since it's nullable
          }
        }
        if( event.eventName == 'elimination-request') {
          final data = _safeJson(event.data);
          if (killRequest != null) {
            killRequest(data); // use ! since it's nullable
          }
        }
        if( event.eventName == 'elimination-confirmed') {
          final data = _safeJson(event.data);
          if (eliminationConfirmed != null) {
            eliminationConfirmed(data); // use ! since it's nullable
          }
        }
      };


    }catch(e){
      log("Error subscribing to chat room $chatRoomId: $e");
    }

  }

  Future<void> unsubEvent(String chatRoomId) async {
    await _pusher.unsubscribe(channelName: 'room-$chatRoomId');
  }
  Future<void> unsubUser(String chatRoomId) async {
    await _pusher.unsubscribe(channelName: 'user-$chatRoomId');
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