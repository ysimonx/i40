class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://myeurevia.com";

  // receiveTimeout
  static const Duration receiveTimeout = Duration(seconds: 15000);

  // connectTimeout
  static const Duration connectionTimeout = Duration(seconds: 15000);

  static const String users = '/users';

  static const String provisionDeviceKey = "a";
  static const String provisionDeviceSecret = "b";
  static const String provision = '/api/v1/provision';
  static const String telemetry = '/api/v1/%s/telemetry';
}
