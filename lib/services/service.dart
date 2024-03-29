import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:geolocator/geolocator.dart';

import '../di/service_locator.dart';
import '../ui/controller.dart';
import 'service_telemetry.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  bool hasPositionBeenRecentlyUpdated = false;
  late Position position;
  late Position positionLowest;

  final Map<String, dynamic> mapBluetoothScannedDevices =
      Map<String, dynamic>();

  final Map<String, dynamic> mapWifiScannedNetworks = Map<String, dynamic>();

  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  setupGetIt();

  final homeController = getIt<HomeController>();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    Platform.isAndroid
        ? () async {
            if (await Permission.bluetoothConnect.isGranted) {
              FlutterBluePlus.instance.turnOff();
            }
          }
        : null;
    service.stopSelf();
  });

  var bluetoothDevicesList = "";

  var subscription = FlutterBluePlus.instance.scanResults.listen((results) {
    // do something with scan results
    print('bluetooth scan :');

    bluetoothDevicesList = "";
    for (ScanResult r in results) {
      bluetoothDevicesList = '${bluetoothDevicesList}, ${r.device.name} ';
      print('${r.device.name} found! id: ${r.device.id} rssi: ${r.rssi}');
      mapBluetoothScannedDevices.putIfAbsent(
          r.device.id.toString(),
          () => {
                "name": r.device.name,
                "rssi": r.rssi,
                "advertisementData": r.advertisementData.toString(),
                "device": r.device.toString()
              });
    }
  });

  // Timer pour envoi data recoltées
  Timer.periodic(const Duration(seconds: 60), (timer) async {
    if (!hasPositionBeenRecentlyUpdated) {
      print("Position has not been recently updated : dont send telemetry");
    } else {
      await sendTelemetry(
          homeController: homeController,
          position: position,
          position_lowest: positionLowest,
          mapBluetoothScannedDevices: mapBluetoothScannedDevices,
          mapWifiScannedNetworks: mapWifiScannedNetworks);
    }

    // reinit collected telemetry data;
    mapBluetoothScannedDevices.clear();
    mapWifiScannedNetworks.clear();
    return;
  });

  // Timer pour collecte Geolocalisation
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    // cf https://stackoverflow.com/a/71761201
    LocationPermission permission;

    hasPositionBeenRecentlyUpdated = false;

    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return;
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    positionLowest = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest);

    hasPositionBeenRecentlyUpdated = true;

    print(
        'Location Position : ${position.longitude.toString()} :${position.latitude.toString()}');
    return;
  });

  // timer pour collecte scan bluetooth
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    var res = await FlutterBluePlus.instance.isOn;
    if (res) {
      if (await Permission.bluetoothConnect.isGranted) {
        FlutterBluePlus.instance.startScan(
            scanMode: ScanMode.lowPower, timeout: const Duration(seconds: 5));
      }
    }
  });

  Timer.periodic(const Duration(seconds: 30), (timer) async {
    final can = await WiFiScan.instance.canStartScan();
    // if can-not, then show error
    if (can != CanStartScan.yes) {
      print("can not scan wifi");
      return;
    }
    final results = await WiFiScan.instance.getScannedResults();
    print(results.toString());
    for (WiFiAccessPoint r in results) {
      mapWifiScannedNetworks.putIfAbsent(
          r.bssid,
          () => {
                "ssid": r.ssid,
                "capabilities": r.capabilities,
                "frequency": r.frequency,
                "level": r.level,
              });
    }
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // if you don't using custom notification, uncomment this
        // service.setForegroundNotificationInfo(
        //   title: "My App Service",
        //   content: "Updated at ${DateTime.now()}",
        // );
      }
    }

    /// you can see this log in logcat
    // ignore: avoid_print
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });

  var res = await FlutterBluePlus.instance.isOn;
  if (!res) {
    if (await Permission.bluetoothConnect.isGranted) {
      FlutterBluePlus.instance.turnOn();
    }
  }
}
