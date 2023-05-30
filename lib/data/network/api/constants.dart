class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://reqres.in/api";

  // receiveTimeout
  static const Duration receiveTimeout = Duration(seconds: 15000);

  // connectTimeout
  static const Duration connectionTimeout = Duration(seconds: 15000);

  static const String users = '/users';
}
