import 'dart:convert';
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
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  // get List Object using this method
  Future<List> getListData(tableName) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      final list = hiveBox.values.toList();
      return list;
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  Future<int> getListLength(tableName) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      final listCount = hiveBox.values.toList();
      return listCount.length;
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  Future<bool> updateListData(tableName, index, value) async {
    try {
      final hiveBox = await Hive.openBox(tableName);

      hiveBox.putAt(index, value);

      return true;
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }

  Future<bool> deleteData(tableName, index) async {
    try {
      final hiveBox = await Hive.openBox(tableName);
      hiveBox.deleteAt(index);

      return true;
    } catch (e) {
      if (e.toString().contains("Failed host lookup")) {
        throw ("NO_CONNECTION");
      } else {
        throw (e);
      }
    }
  }
}
