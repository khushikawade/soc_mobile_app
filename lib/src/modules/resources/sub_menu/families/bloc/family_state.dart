// part of 'family_bloc.dart';

// abstract class FamilyState extends Equatable {
//   const FamilyState();
// }

// class FamilyInitial extends FamilyState {
//   @override
//   List<Object> get props => [];
// }

// class FamilyLoading extends FamilyState {
//   @override
//   List<Object> get props => [];
// }

// class ErrorLoading extends FamilyState {
//   final err;
//   ErrorLoading({this.err});
//   ErrorLoading copyWith({final err}) {
//     return ErrorLoading(err: err ?? this.err);
//   }

//   @override
//   List<Object> get props => [err];
// }

// // ignore: must_be_immutable
// class FamiliesDataSucess extends FamilyState {
//   List<FamiliesList>? obj;
//   FamiliesDataSucess({
//     this.obj,
//   });
//   FamiliesDataSucess copyWith({
//     final obj,
//   }) {
//     return FamiliesDataSucess(obj: obj ?? this.obj);
//   }

//   @override
//   List<Object> get props => [];
// }

// class FamiliesSublistSucess extends FamilyState {
//   List<FamiliesSubList>? obj;

//   FamiliesSublistSucess({
//     this.obj,
//   });

//   FamiliesSublistSucess copyWith({
//     final obj,
//   }) {
//     return FamiliesSublistSucess(obj: obj ?? this.obj);
//   }

//   @override
//   List<Object> get props => [];
// }

// // class SDDataSucess extends FamilyState {
// //   List<SDlist>? obj;
// //   SDDataSucess({
// //     this.obj,
// //   });
// //   SDDataSucess copyWith({
// //     final obj,
// //   }) {
// //     return SDDataSucess(obj: obj ?? this.obj);
// //   }

// //   @override
// //   List<Object> get props => [];
// // }

// // class CalendarListSuccess extends FamilyState {
// //   List<CalendarEventList>? pastListobj;
// //   List<CalendarEventList>? futureListobj;
// //   CalendarListSuccess({this.pastListobj, this.futureListobj});
// //   CalendarListSuccess copyWith({
// //     final obj,
// //   }) {
// //     return CalendarListSuccess(
// //         pastListobj: obj ?? this.pastListobj,
// //         futureListobj: obj ?? this.futureListobj);
// //   }

// //   @override
// //   List<Object> get props => [];
// // }
