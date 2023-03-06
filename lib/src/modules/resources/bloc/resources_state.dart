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

class ResourcesDataSuccess extends ResourcesState {
  final List<SharedList>? obj;
  ResourcesDataSuccess({
    this.obj,
  });
  ResourcesDataSuccess copyWith({
    final obj,
  }) {
    return ResourcesDataSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class ResourcesSubListSuccess extends ResourcesState {
  final List<SharedList>? obj;
  final List<SharedList>? subFolder;
  ResourcesSubListSuccess({this.obj, this.subFolder});
  ResourcesSubListSuccess copyWith({final obj, final subFolder}) {
    return ResourcesSubListSuccess(
        obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
  }

  @override
  List<Object> get props => [];
}
