import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;

  WebSocketManager._internal();

  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  final StreamController<dynamic> _controller =
      StreamController<dynamic>.broadcast();

  Stream<dynamic> get stream => _controller.stream;

  /// 🔗 Connect
  Future<void> connect(String url) async {
    try {
      print("🔌 Connecting to WebSocket...");

      _channel = IOWebSocketChannel.connect(url);

      _subscription = _channel!.stream.listen(
        (message) {
          print("📩 Message: $message");

          try {
            final decoded = jsonDecode(message);
            _controller.add(decoded);

            /// 👉 Handle Pusher events
            _handlePusherEvent(decoded);
          } catch (e) {
            _controller.add(message);
          }
        },
        onDone: () {
          print("❌ Socket closed");
          _isConnected = false;
          _reconnect(url);
        },
        onError: (error) {
          print("⚠️ Error: $error");
          _isConnected = false;
          _reconnect(url);
        },
      );

      _isConnected = true;
      print("✅ Connected");
    } catch (e) {
      print("❌ Connection failed: $e");
      _reconnect(url);
    }
  }

  /// 🔁 Auto Reconnect
  void _reconnect(String url) {
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected) {
        print("🔄 Reconnecting...");
        connect(url);
      }
    });
  }

  /// 📤 Send message
  void send(dynamic data) {
    if (_channel != null && _isConnected) {
      final message = jsonEncode(data);
      print("📤 Sending: $message");
      _channel!.sink.add(message);
    } else {
      print("⚠️ Cannot send, socket not connected");
    }
  }

  /// ❌ Disconnect
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close(status.goingAway);
    _isConnected = false;
    print("🔌 Disconnected");
  }

  /// 🔥 Pusher Subscribe Example
  void subscribe(String channelName) {
    final data = {
      "event": "pusher:subscribe",
      "data": {"channel": channelName},
    };

    send(data);
  }

  /// 💡 Handle Pusher Events
  void _handlePusherEvent(dynamic data) {
    final event = data['event'];

    /// ✅ Connection established
    if (event == 'pusher:connection_established') {
      print("🎉 Pusher Connected");

      /// 👉 Auto subscribe here (BEST PRACTICE)
      subscribe("price-channel");
      subscribe("market-crash-channel");
    }

    /// ✅ Subscription success
    /// ✅ Subscription success
    if (event == 'pusher_internal:subscription_succeeded') {
      final channel = data['channel'];
      print("✅ Subscribed: $channel");
    }

    /// ✅ Market crash event
    if (event == 'market.crash' || event == '.market.crash') {
      try {
        final rawData = data['data'];
        final parsedData = rawData is String ? jsonDecode(rawData) : rawData;
        _controller.add({"type": "market_crashed", "data": parsedData});
      } catch (e) {
        _controller.add({"type": "market_crashed"});
      }
    }

    /// ✅ Custom Event: price.updated
    if (event == 'price.updated') {
      try {
        final rawData = data['data'];

        /// ⚠️ IMPORTANT: data is string → decode again
        final parsedData = rawData is String ? jsonDecode(rawData) : rawData;

        final price = parsedData['price'];

        print("💰 Price Update Received: $price");

        /// 👉 Send clean event to UI
        _controller.add({
          "type": "price_updated",
          "product_id": price['product_id'],
          "new_price": price['new_price'],
          "menu_price": price['menu_price'],
        });
      } catch (e) {
        print("❌ Error parsing price.updated: $e");
      }
    }

    /// 👉 Demo: handle ping (optional)
    if (event == 'pusher:ping') {
      print("🏓 Ping received → sending pong");

      send({"event": "pusher:pong", "data": {}});
    }
  }
}
