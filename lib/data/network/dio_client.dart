import 'api/constants.dart';
import 'package:dio/dio.dart';

class DioClient {
// dio instance
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout as Duration?
      ..options.receiveTimeout = Endpoints.receiveTimeout as Duration?
      ..options.responseType = ResponseType.json;
  }
}
