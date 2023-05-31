import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../dio_client.dart';
import 'constants.dart';

class DeviceApi {
  final DioClient dioClient;

  DeviceApi({required this.dioClient});

  Future<Response> provisionDeviceApi(String deviceName) async {
    try {
      var x = {
        "provisionDeviceKey": Endpoints.provisionDeviceKey,
        "provisionDeviceSecret": Endpoints.provisionDeviceSecret,
        "deviceName": deviceName
      };
      var json = jsonEncode(x);

      final Response response = await dioClient.post(
        Endpoints.provision,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: json,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
