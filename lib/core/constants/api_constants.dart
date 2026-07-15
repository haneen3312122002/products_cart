//base api config shared by every feature's remote data source, each data source appends its own path to baseUrl
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://fakestoreapi.com';
  //request timeout:
  static const Duration connectTimeout = Duration(seconds: 15);
  //response timeout:
  static const Duration receiveTimeout = Duration(seconds: 15);
}
