import 'package:dio/dio.dart';

import '../models/device.dart';
import '../network/api/device_api.dart';
import '../network/dio_exception.dart';

class DeviceRepository {
  final DeviceApi deviceApi;

  DeviceRepository(this.deviceApi);

  Future<ProvisioningResponse> provisionDevice(String deviceName) async {
    try {
      final response = await deviceApi.provisionDeviceApi(deviceName);
      return ProvisioningResponse.fromJson(response.data);
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
