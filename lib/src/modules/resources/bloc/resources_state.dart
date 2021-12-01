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

class ResourcesDataSucess extends ResourcesState {
  final List<SharedList>? obj;
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

class ResourcesSubListSucess extends ResourcesState {
  final List<SharedList>? obj;
  final List<SharedList>? subFolder;
  ResourcesSubListSucess({this.obj, this.subFolder});
  ResourcesSubListSucess copyWith({final obj, final subFolder}) {
    return ResourcesSubListSucess(
        obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
  }

  @override
  List<Object> get props => [];
}
