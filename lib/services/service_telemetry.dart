import 'package:geolocator/geolocator.dart';

Future<void> sendTelemetry(
    {homeController,
    position,
    position_lowest,
    mapBluetoothScannedDevices,
    required Map<String, dynamic> mapWifiScannedNetworks}) async {
  Map<String, dynamic> telemetry = {
    "longitude": position.longitude,
    "latitude": position.latitude,
    "position": jsonPosition(position),
    "position_lowest": jsonPosition(position_lowest)
  };

  // si je n'ai pas eu de devices bluetooth scannés, c'est peut etre parce
  // le telephone etait en veille ... et pourtant, les devices sont peut
  // etre présents ... alors, je prefere ne rien envoyer
  if (mapBluetoothScannedDevices.isNotEmpty) {
    telemetry.addAll({"bluetooth": mapBluetoothScannedDevices});
  }

  if (mapWifiScannedNetworks.isNotEmpty) {
    telemetry.addAll({"wifi": mapWifiScannedNetworks});
  }

  await homeController.sendTelemetry(telemetry);

  return;
}

Map<String, dynamic> jsonPosition(Position positionx) {
  return {
    "accuracy": positionx.accuracy,
    "altitude": positionx.altitude,
    "floor": positionx.floor,
    "heading": positionx.heading,
    "speed": positionx.speed,
    "speed_accuracy": positionx.speedAccuracy
  };
}
