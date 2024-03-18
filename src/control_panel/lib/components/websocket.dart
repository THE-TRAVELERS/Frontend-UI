import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Defines a custom websocket for the video flux
class CustomWebSocket {
  // ------------------------- Members ------------------------- //
  late String url;
  WebSocketChannel? _channel;

  // --------------------- Constructor ---------------------- //
  CustomWebSocket(this.url);

  // ---------------------- Getter Setters --------------------- //
  String get getUrl {
    return url;
  }

  set setUrl(String url) {
    this.url = url;
  }

  WebSocketChannel? get getChannel {
    return _channel;
  }

  Stream<dynamic> get stream {
    if (_channel != null) {
      return _channel!.stream;
    } else {
      return const Stream.empty();
    }
  }

  // ---------------------- Functions ----------------------- //

  /// Connects the current application to a websocket
  Future<bool> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      await _channel?.ready;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Disconnects the current application from a websocket
  void disconnect() {
    if (_channel != null) {
      try {
        _channel!.sink.close();
      } catch (e) {
        if (kDebugMode) {
          print('Failed to close WebSocket: $e');
        }
      }
    }
  }
}
