import 'package:flutter/services.dart';

class PlatformServices {
  static const MethodChannel _methodChannel = MethodChannel('os_method');

  static Future<String?> getOsVersion() async {
    final String? version = await _methodChannel.invokeMethod('getOsVersion');
    return version;
  }

  static const EventChannel _eventChannel = EventChannel('os_event');

  static Stream<String> listenConnection() {
    return _eventChannel.receiveBroadcastStream().map((type) {
      if (type == null) {
        return 'unknown';
      } else {
        return type;
      }
    }).cast();
  }
}
