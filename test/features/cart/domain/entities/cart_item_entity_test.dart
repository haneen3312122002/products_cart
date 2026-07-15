import 'package:flutter_test/flutter_test.dart';
import 'package:products_cart/features/cart/domain/entities/cart_item_entity.dart';

void main() {
  const item = CartItemEntity(
    id: '1',
    productId: '1',
    name: 'Test Product',
    price: 9.5,
    image: 'https://example.com/image.png',
    quantity: 3,
  );

  test('subtotal multiplies price by quantity', () {
    expect(item.subtotal, 28.5);
  });

  test('copyWith replaces only quantity and keeps other fields', () {
    final updated = item.copyWith(quantity: 5);

    expect(updated.quantity, 5);
    expect(updated.id, item.id);
    expect(updated.productId, item.productId);
    expect(updated.name, item.name);
    expect(updated.price, item.price);
    expect(updated.image, item.image);
  });

  test('copyWith with no args returns an equal item', () {
    expect(item.copyWith(), item);
  });
}
