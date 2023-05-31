import 'package:flutter/material.dart';

import '../data/models/device.dart';
import '../di/service_locator.dart';
import 'controller.dart';

class Provision extends StatelessWidget {
  Provision({Key? key}) : super(key: key);
  final homeController = getIt<HomeController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service App'),
        ),
        body: FutureBuilder<Device>(
            future: homeController.provisionDevice("testYS"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final error = snapshot.error;
                return Center(
                  child: Text(
                    "Error: " + error.toString(),
                  ),
                );
              } else if (snapshot.hasData) {
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
                String s = "Provisionning ${token}";

                return Center(child: Text(s));
              } else {
                return const Center(
                  child: Text('No data'),
                );
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
