import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:products_cart/core/error/failures.dart';
import 'package:products_cart/core/usecase/usecase.dart';
import 'package:products_cart/features/cart/domain/entities/cart_item_entity.dart';
import 'package:products_cart/features/cart/domain/usecases/add_to_cart.dart';
import 'package:products_cart/features/cart/domain/usecases/decrease_cart_item_quantity.dart';
import 'package:products_cart/features/cart/domain/usecases/get_cart_items.dart';
import 'package:products_cart/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:products_cart/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:products_cart/features/cart/presentation/cubit/cart_cubit.dart';

class MockGetCartItems extends Mock implements GetCartItems {}

class MockAddToCart extends Mock implements AddToCart {}

class MockRemoveFromCart extends Mock implements RemoveFromCart {}

class MockUpdateCartQuantity extends Mock implements UpdateCartQuantity {}

class MockDecreaseCartItemQuantity extends Mock
    implements DecreaseCartItemQuantity {}

void main() {
  late MockGetCartItems getCartItems;
  late MockAddToCart addToCart;
  late MockRemoveFromCart removeFromCart;
  late MockUpdateCartQuantity updateCartQuantity;
  late MockDecreaseCartItemQuantity decreaseCartItemQuantity;
  late CartCubit cubit;

  const item = CartItemEntity(
    id: '1',
    productId: '1',
    name: 'Test Product',
    price: 10,
    image: 'https://example.com/image.png',
    quantity: 1,
  );

  setUpAll(() {
    registerFallbackValue(const AddToCartParams(item));
    registerFallbackValue(const RemoveFromCartParams('1'));
    registerFallbackValue(
      const UpdateCartQuantityParams(cartItemId: '1', quantity: 1),
    );
    registerFallbackValue(const DecreaseCartItemQuantityParams('1'));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getCartItems = MockGetCartItems();
    addToCart = MockAddToCart();
    removeFromCart = MockRemoveFromCart();
    updateCartQuantity = MockUpdateCartQuantity();
    decreaseCartItemQuantity = MockDecreaseCartItemQuantity();
    cubit = CartCubit(
      getCartItems: getCartItems,
      addToCart: addToCart,
      removeFromCart: removeFromCart,
      updateCartQuantity: updateCartQuantity,
      decreaseCartItemQuantity: decreaseCartItemQuantity,
    );
  });

  tearDown(() => cubit.close());

  group('loadCart', () {
    blocTest<CartCubit, CartState>(
      'emits [CartLoading, CartLoaded] when items are fetched successfully',
      setUp: () {
        when(
          () => getCartItems(any()),
        ).thenAnswer((_) async => const Right([item]));
      },
      build: () => cubit,
      act: (c) => c.loadCart(),
      expect: () => [const CartLoading(), const CartLoaded([item])],
    );

    blocTest<CartCubit, CartState>(
      'emits [CartLoading, CartError] when fetching fails',
      setUp: () {
        when(
          () => getCartItems(any()),
        ).thenAnswer((_) async => const Left(CacheFailure('boom')));
      },
      build: () => cubit,
      act: (c) => c.loadCart(),
      expect: () => [const CartLoading(), const CartError('boom')],
    );
  });

  group('addItem', () {
    blocTest<CartCubit, CartState>(
      'reloads the cart after successfully adding an item',
      setUp: () {
        when(
          () => addToCart(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => getCartItems(any()),
        ).thenAnswer((_) async => const Right([item]));
      },
      build: () => cubit,
      act: (c) => c.addItem(item),
      expect: () => [const CartLoading(), const CartLoaded([item])],
      verify: (_) {
        verify(() => addToCart(const AddToCartParams(item))).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits CartError without reloading when adding fails',
      setUp: () {
        when(
          () => addToCart(any()),
        ).thenAnswer((_) async => const Left(CacheFailure('add failed')));
      },
      build: () => cubit,
      act: (c) => c.addItem(item),
      expect: () => [const CartError('add failed')],
      verify: (_) {
        verifyNever(() => getCartItems(any()));
      },
    );
  });

  group('removeItem', () {
    blocTest<CartCubit, CartState>(
      'reloads the cart after successfully removing an item',
      setUp: () {
        when(
          () => removeFromCart(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => getCartItems(any()),
        ).thenAnswer((_) async => const Right([]));
      },
      build: () => cubit,
      act: (c) => c.removeItem('1'),
      expect: () => [const CartLoading(), const CartLoaded([])],
      verify: (_) {
        verify(
          () => removeFromCart(const RemoveFromCartParams('1')),
        ).called(1);
      },
    );
  });

  group('updateQuantity', () {
    blocTest<CartCubit, CartState>(
      'reloads the cart after successfully updating quantity',
      setUp: () {
        when(
          () => updateCartQuantity(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => getCartItems(any()),
        ).thenAnswer((_) async => const Right([item]));
      },
      build: () => cubit,
      act: (c) => c.updateQuantity('1', 4),
      expect: () => [const CartLoading(), const CartLoaded([item])],
      verify: (_) {
        verify(
          () => updateCartQuantity(
            const UpdateCartQuantityParams(cartItemId: '1', quantity: 4),
          ),
        ).called(1);
      },
    );
  });

  group('decreaseItemQuantity', () {
    blocTest<CartCubit, CartState>(
      'reloads the cart after successfully decreasing quantity',
      setUp: () {
        when(
          () => decreaseCartItemQuantity(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => getCartItems(any()),
        ).thenAnswer((_) async => const Right([]));
      },
      build: () => cubit,
      act: (c) => c.decreaseItemQuantity('1'),
      expect: () => [const CartLoading(), const CartLoaded([])],
      verify: (_) {
        verify(
          () => decreaseCartItemQuantity(
            const DecreaseCartItemQuantityParams('1'),
          ),
        ).called(1);
      },
    );
  });
}
