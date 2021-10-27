part of 'resources_bloc.dart';

abstract class ResourcesState extends Equatable {
  const ResourcesState();
}

class ResourcesInitial extends ResourcesState {
  @override
  List<Object> get props => [];
}

class ResourcesLoading extends ResourcesState {
  @override
  List<Object> get props => [];
}

class ResourcesErrorLoading extends ResourcesState {
  final err;
  ResourcesErrorLoading({this.err});
  ResourcesErrorLoading copyWith({final err}) {
    return ResourcesErrorLoading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// ignore: must_be_immutable
class ResourcesDataSucess extends ResourcesState {
  List<ResourcesList>? obj;
  ResourcesDataSucess({
    this.obj,
  });
  ResourcesDataSucess copyWith({
    final obj,
  }) {
    return ResourcesDataSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
