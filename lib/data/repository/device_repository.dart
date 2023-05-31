import 'dart:convert';

import 'package:dio/dio.dart';

import '../../common.dart';
import '../models/device.dart';
import '../network/api/device_api.dart';
import '../network/dio_exception.dart';

class DeviceRepository {
  final DeviceApi deviceApi;

  DeviceRepository(this.deviceApi);

  Future<Device> provisionDevice(String? deviceName) async {
    try {
      final response = await deviceApi.provisionDeviceApi(deviceName);
      var content = jsonDecode(response.toString());
      if (content.containsKey("errorMsg")) {
        final errorMessage = content["errorMsg"];
        throw errorMessage;
      } else {
        ProvisioningResponse pr = ProvisioningResponse.fromJson(content);
        await setClientCloudToken(pr.credentialsValue);

        Device d = Device(deviceName: deviceName, provisioningResponse: pr);
        return d;
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
