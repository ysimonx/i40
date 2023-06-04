import 'dart:async';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionBluetoothWidget extends StatefulWidget {
  const PermissionBluetoothWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return PermissionBluetoothWidgetState();
  }
}

class PermissionBluetoothWidgetState extends State<PermissionBluetoothWidget> {
  bool isBluetoothEnabled = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (_) async {
      bool previousIsBluetoothEnabled = this.isBluetoothEnabled;

      try {
        final granted = await Permission.bluetoothScan.isGranted;
        if (granted) {
          this.isBluetoothEnabled = true;
          if (this.isBluetoothEnabled != previousIsBluetoothEnabled)
            setState(() {});
          return;
        }

        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetooth,
          Permission.bluetoothConnect,
          Permission.bluetoothScan

          //add more permission to request here.
        ].request();

        if (statuses[Permission.bluetoothScan]!.isPermanentlyDenied ||
            statuses[Permission.bluetoothScan]!.isDenied) {
          this.isBluetoothEnabled = false;
        }

        if (statuses[Permission.bluetooth]!.isPermanentlyDenied ||
            statuses[Permission.bluetooth]!.isDenied) {
          this.isBluetoothEnabled = false;
        }

        if (statuses[Permission.bluetooth]!.isPermanentlyDenied ||
            statuses[Permission.bluetooth]!.isDenied) {
          this.isBluetoothEnabled = false;
        }

        if (this.isBluetoothEnabled != previousIsBluetoothEnabled)
          setState(() {});
      } catch (e) {
        rethrow;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: (() {
      if (!isBluetoothEnabled) {
        // Check Bool and show different text
        return ElevatedButton(
          child: Text("Verify Bluetooth Permissions"),
          onPressed: () async {
            // openAppSettings();

            // You can request multiple permissions at once.
            Map<Permission, PermissionStatus> statuses = await [
              Permission.bluetooth,
              Permission.bluetoothConnect,
              Permission.bluetoothScan
              //add more permission to request here.
            ].request();

            if (statuses[Permission.bluetoothScan]!.isPermanentlyDenied) {
              openAppSettings();
            }
          },
        );
      } else
        return Text("Permissions Bluetooth ok");
    }())));
  }
}
