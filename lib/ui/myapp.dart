// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:i40/ui/widgets/logview.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common.dart';
import 'widgets/app_bar.dart';
import 'widgets/permission_location.dart';
import 'widgets/permission_bluetooth.dart';
import 'widgets/permission_notification.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "Stop Service";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: theme(),
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: BaseAppBar(),
            body: Column(
              children: [
                StreamBuilder<Map<String, dynamic>?>(
                  stream: FlutterBackgroundService().on('update'),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final data = snapshot.data!;
                    String? device = data["device"];
                    DateTime? date = DateTime.tryParse(data["current_date"]);
                    return Column(
                      children: [
                        Text(device ?? 'Unknown'),
                        Text(date.toString()),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text("Foreground Mode"),
                  onPressed: () {
                    FlutterBackgroundService().invoke("setAsForeground");
                  },
                ),
                ElevatedButton(
                  child: const Text("Background Mode"),
                  onPressed: () {
                    FlutterBackgroundService().invoke("setAsBackground");
                  },
                ),
                ElevatedButton(
                  child: Text(text),
                  onPressed: () async {
                    final service = FlutterBackgroundService();
                    var isRunning = await service.isRunning();
                    if (isRunning) {
                      service.invoke("stopService");
                    } else {
                      service.startService();
                    }

                    if (!isRunning) {
                      text = 'Stop Service';
                    } else {
                      text = 'Start Service';
                    }
                    setState(() {});
                  },
                ),
                const Expanded(
                  child: LogView(),
                ),
                const PermissionLocationWidget(),
                const PermissionBluetoothWidget(),
                const PermissionNotificationWidget(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.play_arrow),
            ),
          );
        }));
  }
}
