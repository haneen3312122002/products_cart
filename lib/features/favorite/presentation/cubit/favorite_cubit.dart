import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';

part 'favorite_state.dart';
part 'favorite_cubit.freezed.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({
    required GetFavorites getFavorites,
    required ToggleFavorite toggleFavorite,
  }) : _getFavorites = getFavorites,
       _toggleFavorite = toggleFavorite,
       super(const FavoriteState.initial());

  final GetFavorites _getFavorites;
  final ToggleFavorite _toggleFavorite;

  Future<void> loadFavorites() async {
    emit(const FavoriteState.loading());
    final result = await _getFavorites(const NoParams());
    result.fold(
      (failure) => emit(FavoriteState.error(failure.message)),
      (favorites) => emit(FavoriteState.loaded(favorites)),
    );
  }

  Future<void> toggle(FavoriteEntity favorite) async {
    final result = await _toggleFavorite(ToggleFavoriteParams(favorite));
    result.fold(
      (failure) => emit(FavoriteState.error(failure.message)),
      (_) => loadFavorites(),
    );
  }

  bool isFavorite(int productId) {
    final currentState = state;
    if (currentState is FavoriteLoaded) {
      return currentState.favorites.any((f) => f.productId == productId);
    }
    return false;
  }
}
