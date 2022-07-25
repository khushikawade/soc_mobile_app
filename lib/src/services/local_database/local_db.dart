import 'package:Soc/src/services/local_database/irepository.dart';
import 'package:hive/hive.dart';

class LocalDatabase<T> extends IRepository<T> {
  Box<T>? box;
  String tableName;

  LocalDatabase(this.tableName);

  openBox(String tableName) async {
    box = await Hive.openBox<T>(tableName);
  }

  @override
  Future<void> addData(T object) async {
    if (boxIsClosed) {
      await openBox(this.tableName);
    }
    box!.add(object);
  }

  @override
  Future<List<T>> getData() async {
    if (boxIsClosed) {
      await openBox(this.tableName);
    }
    final list = box?.values.toList();
    return list ?? [];
  }

  @override
  Future<void> clear() async {
    if (boxIsClosed) {
      await openBox(this.tableName);
    }
    await box!.clear();
  }

  @override
  Future<void> close() async {
    await box!.close();
  }
  

  Future<void> putAt(int index, T object) async {
    if (boxIsClosed) {
      await openBox(this.tableName);
    }
    box!.putAt(index, object);
  }

  Future<void> deleteAt(
    int index,
  ) async {
    if (boxIsClosed) {
      await openBox(this.tableName);
    }
    box!.deleteAt(
      index,
    );
  }

  bool get boxIsClosed => !(box != null && box!.isOpen);
}
