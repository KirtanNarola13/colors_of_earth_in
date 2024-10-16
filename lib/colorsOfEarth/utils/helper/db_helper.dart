import 'dart:developer';

import 'package:get/get.dart'; // Import Get for snackbar
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper dbHelper = DbHelper._();
  String table_name = 'wishlist';
  String id = 'id';
  String product = 'product';
  static Database? database;

  Future<void> initDB() async {
    try {
      String path = await getDatabasesPath();
      String dbPath = join(path, 'demo.db');

      database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) {
          String query =
              "CREATE TABLE IF NOT EXISTS $table_name($id INTEGER PRIMARY KEY AUTOINCREMENT,$product TEXT);";
          db.execute(query);
        },
      );
    } catch (e) {
      Get.snackbar(
          'Error', 'Oops, something went wrong during DB initialization');
      log('Error in initDB: $e');
    }
  }

  Future<bool> checkAvailable({required String productId}) async {
    await initDB();
    bool isAvailable = false;

    try {
      String query = "SELECT * FROM $table_name WHERE $product = ?;";
      List args = [productId];
      List<Map<String, dynamic>>? list = await database?.rawQuery(query, args);

      if (list != null && list.isNotEmpty) {
        isAvailable = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong checking availability');
      log('Error in checkAvailable: $e');
    }

    return isAvailable;
  }

  Future<int?> insertProduct({required String productId}) async {
    await initDB();

    try {
      String query = "INSERT INTO $table_name($product) VALUES(?);";
      List args = [productId];
      int? res = await database?.rawInsert(query, args);

      return res;
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong inserting product');
      log('Error in insertProduct: $e');
    }

    return null;
  }

  Future<List<Map<String, dynamic>>?> fetchProduct() async {
    await initDB();

    try {
      String query = "SELECT * FROM $table_name;";
      List<Map<String, dynamic>>? list = await database?.rawQuery(query);

      if (list == null) return null;

      List<Map<String, dynamic>> uniqueList = [];
      Set<String> seenProducts = {};

      for (var e in list) {
        String productId = e['product'].toString();
        if (!seenProducts.contains(productId)) {
          seenProducts.add(productId);
          uniqueList.add(e);
        } else {
          deleteProduct(e['id'].toString());
        }
      }

      return uniqueList;
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong fetching products');
      log('Error in fetchProduct: $e');
    }

    return null;
  }

  Future<int?> deleteProduct(String dId) async {
    await initDB();

    try {
      if (database == null) {
        log("database is null");
      }

      List args = [dId];
      int? result = await database?.delete(
        table_name,
        where: '$id = ?',
        whereArgs: args,
      );

      // Log the result of the delete operation
      log('Deleted rows: $result');

      return result;
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong deleting product');
      log('Error in deleteProduct: $e');
    }

    return null;
  }
}
