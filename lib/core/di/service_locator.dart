import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:products_cart/features/product/domain/usecases/get_product_by_id.dart';
import 'package:products_cart/features/product/presentation/cubit/product_details/product_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_service.dart';
import '../network/network_info.dart';
import '../database/app_database.dart';
import '../../features/product/data/datasources/product_local_data_source.dart';
import '../../features/product/data/datasources/product_remote_data_source.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_products.dart';
import '../../features/product/presentation/cubit/products_list/products_cubit.dart';
import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/get_cart_items.dart';
import '../../features/cart/domain/usecases/add_to_cart.dart';
import '../../features/cart/domain/usecases/remove_from_cart.dart';
import '../../features/cart/domain/usecases/update_cart_quantity.dart';
import '../../features/cart/domain/usecases/decrease_cart_item_quantity.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/favorite/data/datasources/favorite_local_data_source.dart';
import '../../features/favorite/data/repositories/favorite_repository_impl.dart';
import '../../features/favorite/domain/repositories/favorite_repository.dart';
import '../../features/favorite/domain/usecases/get_favorites.dart';
import '../../features/favorite/domain/usecases/toggle_favorite.dart';
import '../../features/favorite/domain/usecases/is_favorite.dart';
import '../../features/favorite/presentation/cubit/favorite_cubit.dart';

final GetIt sl = GetIt.instance;

// registers every dependency for every feature, call once in main()
Future<void> setupServiceLocator() async {
  //Core:
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );
  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPref);
  sl.registerLazySingleton(() => AppDatabase.instance);
  //Product:
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //usecase:
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));

  sl.registerFactory(() => ProductsCubit(getProducts: sl()));
  sl.registerFactory(() => ProductCubit(getProductById: sl()));

  //Cart:
  //datasourse
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(database: sl()),
  );
  //repo
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );
  //usecases
  sl.registerLazySingleton(() => GetCartItems(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => UpdateCartQuantity(sl()));
  sl.registerLazySingleton(() => DecreaseCartItemQuantity(sl()));
  //cubit
  sl.registerLazySingleton(
    () => CartCubit(
      addToCart: sl(),
      removeFromCart: sl(),
      getCartItems: sl(),
      updateCartQuantity: sl(),
      decreaseCartItemQuantity: sl(),
    ),
  );
  //Favorite:
  sl.registerLazySingleton<FavoriteLocalDataSource>(
    () => FavoriteLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => IsFavorite(sl()));
  sl.registerLazySingleton(
    () => FavoriteCubit(getFavorites: sl(), toggleFavorite: sl()),
  );
}
