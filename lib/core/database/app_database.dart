import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//shared database
class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase instance = AppDatabase._internal();

  static Database? _database;
  //getter:
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'products_cart.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // safe-migration: previously dropped and recreated cart_items on every
  // upgrade, silently wiping the user's saved cart. Now it only adds what's
  // missing so existing rows survive future version bumps.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='cart_items'",
      );
      if (tables.isEmpty) {
        await _onCreate(db, newVersion);
      }
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // tables:

    await db.execute('''
      CREATE TABLE cart_items(
        id TEXT PRIMARY KEY,
        productId TEXT NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT,
        quantity INTEGER NOT NULL
      )
    ''');
  }
}
