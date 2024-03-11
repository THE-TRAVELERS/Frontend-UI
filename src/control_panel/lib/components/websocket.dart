import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

/// Defines a custom websocket for the video flux
class WebSocket {
  // ------------------------- Members ------------------------- //
  late String url;
  WebSocketChannel? _channel;
  StreamController<bool> streamController = StreamController<bool>.broadcast();

  // --------------------- Constructor ---------------------- //
  WebSocket(this.url);
  
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
  void connect() async {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  /// Disconnects the current application from a websocket
  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
    }
  }
}
