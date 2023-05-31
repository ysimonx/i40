import 'package:dio/dio.dart';

import '../dio_client.dart';
import 'constants.dart';

class DeviceApi {
  final DioClient dioClient;

  DeviceApi({required this.dioClient});

  Future<Response> provisionDeviceApi(String deviceName) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.provision,
        data: {
          "provisionDeviceKey": Endpoints.provisionDeviceKey,
          "provisionDeviceSecret": Endpoints.provisionDeviceSecret,
          'deviceName': deviceName
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
