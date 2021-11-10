part of 'resources_bloc.dart';

abstract class ResourcesEvent extends Equatable {
  const ResourcesEvent();
}

class ResourcesListEvent extends ResourcesEvent {
  @override
  List<Object> get props => [];
}

class ResourcesSublistEvent extends ResourcesEvent {
  final String? id;
  ResourcesSublistEvent({
    required this.id,
  });
  @override
  List<Object> get props => [id!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $id}';
}
