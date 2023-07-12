import 'package:hive/hive.dart';

class HiveDbServices {
  // Local DB operations.

  // add Data in data base using this method
  Future<bool> addData(model, tableName) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      hiveBox.add(model);
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> putData(String tableName, dynamic data,
      {String key = 'data'}) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      hiveBox.put(key, data);
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> addLocalData(String tableName, dynamic data) async {
    try {
      final hiveBox = await Hive.openBox(tableName);

      return true;
    } catch (e) {
      throw (e);
    }
  }

  // get List Object using this method
  Future<List> getListData(tableName) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      final list = hiveBox.values.toList();
      return list;
    } catch (e) {
      throw (e);
    }
  }

  Future<List> getRecordObject(tableName) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      final list = hiveBox.values.toList();
      return list;
    } catch (e) {
      throw (e);
    }
  }

  Future<int> getListLength(tableName) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      final listCount = hiveBox.values.toList();
      return listCount.length;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> updateListData(tableName, index, value) async {
    try {
      final hiveBox = await Hive.openBox(tableName);

      hiveBox.putAt(index, value);

      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> deleteData(tableName, index) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      hiveBox.deleteAt(index);
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> clearAll(String tableName) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      await hiveBox.clear();
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> addSingleData(String tableName, key, value) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      await hiveBox.put(key, value);
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future getSingleData(String tableName, key) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      var data = await hiveBox.get(key);
      return data;
    } catch (e) {
      throw (e);
    }
  }
}
