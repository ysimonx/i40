import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:android_id/android_id.dart';

const secureStorage = FlutterSecureStorage();

Future setClientCloudToken(String? token) async {
  var key = "token";
  await secureStorage.write(key: key, value: token);
}

Future<String?> getClientCloudToken() async {
  // Create storage

// Read value
  var key = "token";
  String? value =
      await secureStorage.read(key: key, aOptions: _getAndroidOptions());

  return value;
}

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
      // sharedPreferencesName: 'Test2',
      // preferencesKeyPrefix: 'Test'
    );

Future<String?> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String? deviceId;

  if (kIsWeb) {
    final webBrowserInfo = await deviceInfo.webBrowserInfo;

    deviceId =
        '${webBrowserInfo.vendor ?? '-'} + ${webBrowserInfo.userAgent ?? '-'} + ${webBrowserInfo.hardwareConcurrency.toString()}';
  } else if (Platform.isAndroid) {
    const androidId = AndroidId();

    deviceId = await androidId.getId();
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;

    deviceId = iosInfo.identifierForVendor;
  } else if (Platform.isLinux) {
    final linuxInfo = await deviceInfo.linuxInfo;

    deviceId = linuxInfo.machineId;
  } else if (Platform.isWindows) {
    final windowsInfo = await deviceInfo.windowsInfo;

    deviceId = windowsInfo.deviceId;
  } else if (Platform.isMacOS) {
    final macOsInfo = await deviceInfo.macOsInfo;

    deviceId = macOsInfo.systemGUID;
  }

  return deviceId;
}
