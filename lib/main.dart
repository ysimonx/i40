// ignore_for_file: depend_on_referenced_packages, unused_import

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:i40/common.dart';
import 'package:i40/services/service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/models/device.dart';
import 'ui/myapp.dart';
import 'ui/provision.dart';

// cf https://stackoverflow.com/a/44788660 pout streambuilder

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeService();

  String? x = await getClientCloudToken();

  Widget nextScreen = const MyApp();
  if (x == null) {
    // nextScreen = const Provision();
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
