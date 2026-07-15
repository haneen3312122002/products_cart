part of 'favorite_cubit.dart';

@freezed
class FavoriteState with _$FavoriteState {
  const factory FavoriteState.initial() = FavoriteInitial;
  const factory FavoriteState.loading() = FavoriteLoading;
  const factory FavoriteState.loaded(List<FavoriteEntity> favorites) =
      FavoriteLoaded;
  const factory FavoriteState.error(String message) = FavoriteError;
}
