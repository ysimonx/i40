import 'package:flutter/material.dart';

import '../data/models/device.dart';
import '../di/service_locator.dart';
import 'controller.dart';

class Provision extends StatelessWidget {
  final String? deviceName;

  Provision({Key? key, required this.deviceName}) : super(key: key);
  final homeController = getIt<HomeController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service App'),
        ),
        body: FutureBuilder<Device>(
            future: homeController.provisionDevice(deviceName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final error = snapshot.error;
                return Center(child: Text("Error: " + error.toString()));
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text('No data'),
                );
              } else {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('empty data'),
                  );
                }

                Device? d = snapshot.data;
                String? token = "empty";
                if (d != null) {
                  token = d.provisioningResponse?.credentialsValue;
                }
                String s = "token is ${token}";

                return Center(
                    child: Container(
                        width: 300,
                        height: 300,
                        child: ListView(shrinkWrap: true, children: [
                          Text(s),
                          const Text("test"),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("Suite"),
                          )
                        ])));
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
