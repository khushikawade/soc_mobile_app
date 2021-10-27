part of 'resources_bloc.dart';

abstract class ResourcesEvent extends Equatable {
  const ResourcesEvent();
}

class ResourcesListEvent extends ResourcesEvent {
  @override
  List<Object> get props => [];
}