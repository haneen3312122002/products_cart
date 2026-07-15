import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  const ProductRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;

  static const String _productsEndpoint = '/products';

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiService.get(_productsEndpoint);
      final data = response.data as List<dynamic>;
      return data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(_messageForDioError(e));
    } catch (_) {
      throw const ServerException('Failed to parse products response');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiService.get('$_productsEndpoint/$id');
      return ProductModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_messageForDioError(e));
    } catch (_) {
      throw const ServerException('Failed to parse product response');
    }
  }

  // clearer-errors: this used to be a blanket `catch (_)` that discarded the
  // real cause (timeout vs. 404 vs. malformed JSON), surfacing the same
  // generic message for every failure. Now the Dio error type and, where
  // available, the HTTP status code are preserved in the message.
  String _messageForDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode ?? 'unknown'}).';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return e.message ?? 'Failed to reach the server.';
    }
  }
}
