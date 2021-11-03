// part of 'student_bloc.dart';

// abstract class StudentState extends Equatable {
//   const StudentState();
// }

// class StudentInitial extends StudentState {
//   @override
//   List<Object> get props => [];
// }

// class Loading extends StudentState {
//   @override
//   List<Object> get props => [];
// }

// class StudentError extends StudentState {
//   final err;
//   StudentError({this.err});
//   StudentError copyWith({final err}) {
//     return StudentError(err: err ?? this.err);
//   }

//   @override
//   List<Object> get props => [err];
// }

// // ignore: must_be_immutable
// class StudentDataSucess extends StudentState {
//   List<StudentApp>? obj;
//   List<StudentApp>? subFolder;

//   StudentDataSucess({this.obj, this.subFolder});

//   StudentDataSucess copyWith({final obj, final subFolder}) {
//     return StudentDataSucess(
//         obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
//   }

//   @override
//   List<Object> get props => [];
// }
