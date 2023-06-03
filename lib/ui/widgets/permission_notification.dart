import 'dart:async';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionNotificationWidget extends StatefulWidget {
  const PermissionNotificationWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return PermissionNotificationWidgetState();
  }
}

class PermissionNotificationWidgetState
    extends State<PermissionNotificationWidget> {
  bool isNotificationEnabled = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (_) async {
      bool previousIsNotificationEnabled = this.isNotificationEnabled;

      try {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.notification

          //add more permission to request here.
        ].request();

        if (statuses[Permission.notification]!.isPermanentlyDenied ||
            statuses[Permission.notification]!.isDenied) {
          this.isNotificationEnabled = false;
        } else {
          this.isNotificationEnabled = true;
        }

        if (this.isNotificationEnabled != previousIsNotificationEnabled)
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
      if (!isNotificationEnabled) {
        // Check Bool and show different text
        return ElevatedButton(
          child: Text("Verify Notification Permissions"),
          onPressed: () async {
            // openAppSettings();

            // You can request multiple permissions at once.
            Map<Permission, PermissionStatus> statuses = await [
              Permission.notification
              //add more permission to request here.
            ].request();

            if (statuses[Permission.notification]!.isPermanentlyDenied) {
              openAppSettings();
            }
          },
        );
      } else
        return Text("Permissions notification ok");
    }())));
  }
}
