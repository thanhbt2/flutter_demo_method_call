import 'package:demo/platform_services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel _methodChannel = MethodChannel('os_method');

  setUp(() {
    _methodChannel.setMockMethodCallHandler((call) async {
      return "13";
    });
  });
  tearDown(() {
    _methodChannel.setMethodCallHandler(null);
  });
  test('getOsVersion', () async {
    expect(await PlatformServices.getOsVersion(), "13");
  });
}
