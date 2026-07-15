//base api config (shared)
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://fakestoreapi.com';
  //request timeout:
  static const Duration connectTimeout = Duration(seconds: 15);
  //response timeout:
  static const Duration receiveTimeout = Duration(seconds: 15);
}
