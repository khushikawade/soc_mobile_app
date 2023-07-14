abstract class IRepository<T> {
  Future<List<T>>? getData();
  Future<void> addData(T object);
  Future<void> close();
  Future<void> clear();
}
