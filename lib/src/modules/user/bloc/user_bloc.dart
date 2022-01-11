// import 'package:Soc/src/services/db_service.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
// part 'user_event.dart';
// part 'user_state.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   UserBloc() : super(UserInitial());
//   final DbServices _dbServices = DbServices();

//   @override
//   Stream<UserState> mapEventToState(
//     UserEvent event,
//   ) async* {
//     if (event is PerfomLogin) {
//       try {
//         yield Loading();
//         await login();
//         yield LoginSuccess();
//       } catch (e) {
//         yield ErrorReceived(err: e);
//       }
//     }
//   }

//   Future login() async {
//     try {
//       await _dbServices.login();
//     } catch (e) {
//       throw (e);
//     }
//   }
// }
