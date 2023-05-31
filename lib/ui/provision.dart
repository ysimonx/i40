import 'package:flutter/material.dart';

import '../di/service_locator.dart';
import 'controller.dart';

class Provision extends StatefulWidget {
  Provision({Key? key}) : super(key: key);
  final homeController = getIt<HomeController>();

  @override
  State<Provision> createState() => _ProvisionState();
}

class _ProvisionState extends State<Provision> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service App'),
        ),
        body: const Center(child: Text("Provisionning")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
