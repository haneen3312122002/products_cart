import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/cart_item_model.dart';

// sqflite-backed local data source, cart is local-only (no remote datasource)
// since cart contents are device-specific
abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();

  Future<void> addToCart(CartItemModel item);

  Future<void> decreaseQuantity(String cartItemId);

  Future<void> removeFromCart(String cartItemId);

  Future<void> updateQuantity(String cartItemId, int quantity);

  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  const CartLocalDataSourceImpl({required this.database});

  final AppDatabase database;

  static const String _table = 'cart_items';

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final db = await database.database;
      final rows = await db.query(_table);
      return rows.map(CartItemModel.fromMap).toList();
    } catch (_) {
      throw const CacheException('Failed to load cart items');
    }
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    try {
      final db = await database.database;
      //if the item is already in the cart
      final existing = await db.query(
        _table,
        where: 'id = ?',
        whereArgs: [item.id],
      );
      if (existing.isNotEmpty) {
        //update the quantity
        final existingItem = CartItemModel.fromMap(existing.first);
        await db.update(
          _table,
          {'quantity': existingItem.quantity + 1},
          where: 'id = ?',
          whereArgs: [item.id],
        );
      } else {
        await db.insert(_table, item.toMap());
      }
    } catch (_) {
      // WARNING edited: removed leftover debug logging (no functional change)
      throw const CacheException('Failed to add item to cart');
    }
  }

  @override
  Future<void> decreaseQuantity(String cartItemId) async {
    try {
      final db = await database.database;
      final existingItem = await db.query(
        _table,
        where: 'id = ?',
        whereArgs: [cartItemId],
      );
      if (existingItem.isNotEmpty) {
        final existing = CartItemModel.fromMap(existingItem.first);
        if (existing.quantity > 1) {
          //decrease the quantity
          await db.update(
            _table,
            {'quantity': existing.quantity - 1},
            where: 'id = ?',
            whereArgs: [cartItemId],
          );
        } else {
          await db.delete(_table, where: 'id = ?', whereArgs: [cartItemId]);
        }
      }
    } catch (_) {
      throw const CacheException('Failed to decrease item quantity');
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    try {
      final db = await database.database;
      await db.delete(_table, where: 'id = ?', whereArgs: [cartItemId]);
    } catch (_) {
      throw const CacheException('Failed to remove item from cart');
    }
  }

  @override
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      final db = await database.database;
      await db.update(
        _table,
        {'quantity': quantity},
        where: 'id = ?',
        whereArgs: [cartItemId],
      );
    } catch (_) {
      throw const CacheException('Failed to update item quantity');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final db = await database.database;
      await db.delete(_table);
    } catch (_) {
      throw const CacheException('Failed to clear cart');
    }
  }
}
