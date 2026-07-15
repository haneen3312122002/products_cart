import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/favorite_model.dart';

// SharedPreferences-backed local data source, favorites are stored as a
// single JSON-encoded list under _favoritesKey
abstract class FavoriteLocalDataSource {
  Future<List<FavoriteModel>> getFavorites();

  Future<void> saveFavorites(List<FavoriteModel> favorites);
  Future<Set<int>> getFavoriteIds();
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  const FavoriteLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String _favoritesKey = 'CACHED_FAVORITES';

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final jsonString = sharedPreferences.getString(_favoritesKey);
      if (jsonString == null) return [];
      return FavoriteModel.decodeList(jsonString);
    } catch (_) {
      throw const CacheException('Failed to load favorites');
    }
  }

  @override
  Future<void> saveFavorites(List<FavoriteModel> favorites) async {
    try {
      await sharedPreferences.setString(
        _favoritesKey,
        FavoriteModel.encodeList(favorites),
      );
    } catch (_) {
      throw const CacheException('Failed to save favorites');
    }
  }

  Future<Set<int>> getFavoriteIds() async {
    try {
      final favorites = await getFavorites();
      return favorites.map((f) => f.productId).toSet();
    } catch (_) {
      throw const CacheException('Failed to load favorite IDs');
    }
  }
}
