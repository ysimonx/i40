class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://vpn.kysoe.com:9090";

  // receiveTimeout
  static const Duration receiveTimeout = Duration(seconds: 15000);

  // connectTimeout
  static const Duration connectionTimeout = Duration(seconds: 15000);

  static const String users = '/users';

  static const String provisionDeviceKey = "l4yp81gmjcg57afvpq8p";
  static const String provisionDeviceSecret = "9wh3ym3qr2e5jlnbbvbo";
  static const String provision = '/api/v1/provision';
  static const String telemetry = '/api/v1/%s/telemetry';
}
