import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProducts implements UseCase<List<ProductEntity>, NoParams> {
  final ProductRepository productRepo;
  GetProducts(this.productRepo);
  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) async {
    return await productRepo.getProducts();
  }
}
