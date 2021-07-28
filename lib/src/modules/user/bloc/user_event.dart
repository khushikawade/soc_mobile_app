part of 'user_bloc.dart';

@immutable
abstract class UserEvent {
  const UserEvent();
}

class PerfomLogin extends UserEvent {
  @override
  List<Object?> get props => [];

  @override
  String toString() => 'PerfomLogin { }';
}

class AutoLogin extends UserEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class LogOut extends UserEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class InitLogin extends UserEvent {
  @override
  String toString() => 'InitLogin';
  @override
  List<Object> get props => [];
}

class PerfomChangePassword extends UserEvent {
  final String oldPassword;
  final String newPassword;

  const PerfomChangePassword({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [oldPassword, newPassword];

  @override
  String toString() =>
      'PerfomLogin { oldPassword: $oldPassword, newPassword: $newPassword }';
}
