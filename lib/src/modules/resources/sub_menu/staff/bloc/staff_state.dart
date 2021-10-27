// part of 'staff_bloc.dart';

// abstract class StaffState extends Equatable {
//   const StaffState();
// }

// class StaffInitial extends StaffState {
//   @override
//   List<Object> get props => [];
// }

// class StaffLoading extends StaffState {
//   @override
//   List<Object> get props => [];
// }

// class ErrorInStaffLoading extends StaffState {
//   final err;
//   ErrorInStaffLoading({this.err});
//   ErrorInStaffLoading copyWith({final err}) {
//     return ErrorInStaffLoading(err: err ?? this.err);
//   }

//   @override
//   List<Object> get props => [err];
// }

// // ignore: must_be_immutable
// class StaffDataSucess extends StaffState {
//   List<StaffList>? obj;
//   List<StaffList>? subFolder;

//   StaffDataSucess({this.obj, this.subFolder});

//   StaffDataSucess copyWith({final obj, final subFolder}) {
//     return StaffDataSucess(
//         obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
//   }

//   @override
//   List<Object> get props => [];
// }

// class StaffSubListSucess extends StaffState {
//   List<StaffSubList>? obj;
//   List<StaffSubList>? subFolder;

//   StaffSubListSucess({this.obj, this.subFolder});

//   StaffSubListSucess copyWith({final obj, final subFolder}) {
//     return StaffSubListSucess(
//         obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
//   }

//   @override
//   List<Object> get props => [];
// }
