import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:products_cart/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:products_cart/features/product/domain/entities/product_entity.dart';
import 'package:products_cart/features/product/presentation/widgets/product_card.dart';

class MockFavoriteCubit extends MockCubit<FavoriteState>
    implements FavoriteCubit {
  @override
  bool isFavorite(int productId) => false;
}

void main() {
  const product = ProductEntity(
    id: 1,
    title: 'Test Product',
    price: 19.99,
    image: '',
  );

  Widget wrap(Widget child) {
    final favoriteCubit = MockFavoriteCubit();
    whenListen(
      favoriteCubit,
      const Stream<FavoriteState>.empty(),
      initialState: const FavoriteState.initial(),
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: BlocProvider<FavoriteCubit>.value(
            value: favoriteCubit,
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('shows title and price', (tester) async {
    await tester.pumpWidget(wrap(const ProductCard(product: product)));

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text(r'$19.99'), findsOneWidget);
  });

  testWidgets('Add to Cart button is visible and triggers onAddToCart', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        ProductCard(product: product, onAddToCart: () => tapped = true),
      ),
    );

    final button = find.widgetWithText(ElevatedButton, 'Add to Cart');
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('onTap fires when the card is tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(ProductCard(product: product, onTap: () => tapped = true)),
    );

    await tester.tap(find.byType(ProductCard));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
