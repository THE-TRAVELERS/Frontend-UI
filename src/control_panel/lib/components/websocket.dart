import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

/// Defines a custom websocket for the video flux
class CustomWebSocket {
  // ------------------------- Members ------------------------- //
  late String url;
  WebSocketChannel? _channel;
  StreamController<bool> streamController = StreamController<bool>.broadcast();

  // --------------------- Constructor ---------------------- //
  CustomWebSocket(this.url);

  // ---------------------- Getter Setters --------------------- //
  String get getUrl {
    return url;
  }

  set setUrl(String url) {
    this.url = url;
  }

  Stream<dynamic> get stream {
    if (_channel != null) {
      return _channel!.stream;
    } else {
      throw WebSocketChannelException("The connection was not established !");
    }
  }

  // ---------------------- Functions ----------------------- //

  /// Connects the current application to a websocket
  Future<bool> connect() async {
    try {
      final socket = await WebSocket.connect(url);
      await socket.close();

      _channel = WebSocketChannel.connect(Uri.parse(url));
      print('Connection successful');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Disconnects the current application from a websocket
  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
    }
  }
}
