import 'package:web_socket_channel/io.dart';

class WebsocketService {
  static WebsocketService? _webSocketService;
  final String websocketUrl;

  factory WebsocketService(String url) {
    _webSocketService ??= WebsocketService._internal(url);
    return _webSocketService!;
  }
  WebsocketService._internal(this.websocketUrl);

  IOWebSocketChannel? channel;

  void init() {
    // INITIATE A CONNECTION THROUGH AN IOWebsocketChannel channel
    channel = IOWebSocketChannel.connect(websocketUrl);
    if (channel != null) {
      // IF CHANNEL IS INITIALIZED AND WEBSOCKET IS CONNECTED
      // LISTEN TO WEBSOCKET EVENTS
      channel!.stream.listen(_eventListener).onDone(_reconnect);
    }
  }

  void _eventListener(dynamic event) {
    if (event == 'message') {
      // PERFORM OPERATIONS ON THE EVENT PAYLOAD
    }
  }

  void _reconnect() {
    // IF CONTROL HAS TRANSFERRED TO THIS FUNCTION, IT MEANS
    // THAT THE WEBSOCKET HAS DISCONNECTED.
    if (channel != null) {
      // CLOSE THE PREVIOUS WEBSOCKET CHANNEL AND ATTEMPT A RECONNECTION
      channel!.sink.close();
      init();
    }
  }
}
