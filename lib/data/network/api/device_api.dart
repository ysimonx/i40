import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../dio_client.dart';
import 'constants.dart';

class DeviceApi {
  final DioClient dioClient;

  DeviceApi({required this.dioClient});

  Future<Response> provisionDeviceApi(String? deviceName) async {
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

  Future<Response> sendTelemetryDeviceApi(
      String token, Map<String, dynamic> telemetryJSON) async {
    String json = jsonEncode(telemetryJSON);

    String uri = Endpoints.telemetry;
    uri = uri.replaceFirst("%ACCESS_TOKEN%", token);
    try {
      final Response response = await dioClient.post(
        uri,
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
