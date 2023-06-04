import 'dart:async';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionLocationWidget extends StatefulWidget {
  const PermissionLocationWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return PermissionLocationWidgetState();
  }
}

class PermissionLocationWidgetState extends State<PermissionLocationWidget> {
  bool isLocationEnabled = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (_) async {
      bool previousIsLocationEnabled = this.isLocationEnabled;

      final granted = await Permission.locationAlways.isGranted;
      if (granted) {
        this.isLocationEnabled = true;
        if (this.isLocationEnabled != previousIsLocationEnabled)
          setState(() {});
        return;
      }

      try {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.locationWhenInUse,
          Permission.locationAlways,
          //add more permission to request here.
        ].request();

        if (statuses[Permission.locationAlways]!.isPermanentlyDenied ||
            statuses[Permission.locationAlways]!.isDenied) {
          this.isLocationEnabled = false;
        } else {
          this.isLocationEnabled = true;
        }

        if (this.isLocationEnabled != previousIsLocationEnabled)
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
      if (!isLocationEnabled) {
        // Check Bool and show different text
        return ElevatedButton(
          child: Text("Verify Location Permissions"),
          onPressed: () async {
            // openAppSettings();

            // You can request multiple permissions at once.
            Map<Permission, PermissionStatus> statuses = await [
              Permission.locationWhenInUse,
              Permission.locationAlways,
              //add more permission to request here.
            ].request();

            if (statuses[Permission.locationAlways]!.isPermanentlyDenied) {
              openAppSettings();
            }

            if (statuses[Permission.locationWhenInUse]!.isDenied) {
              openAppSettings();
              //check each permission status after.
              print("Location locationWhenInUse is denied.");
            }

            if (statuses[Permission.locationAlways]!.isDenied) {
              openAppSettings();
              //check each permission status after.
              print("Location locationAlways is denied.");
            }
          },
        );
      } else
        return Text("Permissions Location ok");
    }())));
  }
}
