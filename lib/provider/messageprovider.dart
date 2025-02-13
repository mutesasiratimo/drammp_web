import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/html.dart';

class MessageNotifierProvider with ChangeNotifier {
  final HtmlWebSocketChannel _channel =
      HtmlWebSocketChannel.connect(Uri.parse("wss://drammp.site/ws/"));
  late final BehaviorSubject<dynamic> _notifyStream = BehaviorSubject()
    ..addStream(_channel.stream);

  MessageNotifierProvider() : super() {
    _notifyStream.listen((value) {});
  }

  BehaviorSubject<dynamic> get notifyStream => _notifyStream;
  Sink<dynamic> get notifyMessageSink => _channel.sink;

  List<dynamic> inbox = [];

  void addInbox(dynamic message) {
    inbox.add(message);
    notifyListeners();
  }
}
