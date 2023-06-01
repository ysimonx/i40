// cf https://github.com/red-star25/dio_blog/tree/main/lib/data/repository
// cf https://dhruvnakum.xyz/networking-in-flutter-dio

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:i40/common.dart';
import 'package:i40/services/service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'di/service_locator.dart';
import 'ui/myapp.dart';
import 'ui/provision.dart';

Future<void> main() async {
  setupGetIt();

  WidgetsFlutterBinding.ensureInitialized();

  await initializeService();

  String? x = await getClientCloudToken();

  Widget nextScreen = const MyApp();
  if (x == null) {
    String? deviceName = await getDeviceId();
    nextScreen = Provision(deviceName: deviceName);
  }

  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    [
      Permission.locationWhenInUse,
      Permission.locationAlways,
      Permission.notification,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.notification,
    ].request().then((status) {
      runApp(nextScreen);
    });
  } else {
    runApp(nextScreen);
  }
}
