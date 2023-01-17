// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
// import 'package:Soc/src/modules/home/ui/home.dart';
// import 'package:Soc/src/modules/ocr/modal/user_info.dart';
// import 'package:Soc/src/modules/ocr/widgets/user_profile.dart';
// import 'package:Soc/src/modules/schedule/bloc/calender_bloc.dart';
// import 'package:Soc/src/modules/schedule/modal/calender_list.dart';
// import 'package:Soc/src/modules/schedule/modal/event.dart';
// import 'package:Soc/src/modules/schedule/ui/day_view.dart';
// import 'package:Soc/src/modules/schedule/ui/month_view.dart';
// import 'package:Soc/src/modules/schedule/ui/week_view.dart';
// import 'package:Soc/src/services/local_database/local_db.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/widgets/app_bar.dart';
// import 'package:Soc/src/widgets/error_widget.dart';

// import 'package:Soc/src/widgets/google_auth_webview.dart';
// import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:calendar_view/calendar_view.dart';
// import 'package:flutter/cupertino.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// import '../../students/ui/student.dart';

// class SchoolCalenderPage extends StatefulWidget {
//   UserInformation studentProfile;
//   SchoolCalenderPage({Key? key, required this.studentProfile})
//       : super(key: key);

//   @override
//   State<SchoolCalenderPage> createState() => _SchoolCalenderPageState();
// }

// class _SchoolCalenderPageState extends State<SchoolCalenderPage> {
//   DateTime get _now => DateTime.now();
//   List<CalendarEventData<Event>> staticEventList = [];
//   CalenderBloc _calenderBloc = CalenderBloc();
//   bool isCalendarLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     staticEventList = EventList.events;
//     _calenderBloc
//         .add(CalenderPageEvent(email: widget.studentProfile.userEmail!));
//     // Future.delayed(Duration(milliseconds: 150), () {
//     //   _checkUserSession();
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: !isCalendarLoaded
//           ? CustomAppBarWidget(
//               marginLeft: 30,
//               appBarTitle: 'Calendar',
//               isSearch: false,
//               sharedPopBodyText: '',
//               sharedPopUpHeaderText: '',
//               isShare: false,
//               isCenterIcon: false,
//               language: Globals.selectedLanguage,
//             )
//           : null,
//       body: BlocBuilder<CalenderBloc, CalenderState>(
//           bloc: _calenderBloc,
//           builder: (BuildContext contxt, CalenderState state) {
//             if (state is Loading) {
//               return Center(
//                   child: CircularProgressIndicator(
//                 color: Theme.of(context).colorScheme.primaryVariant,
//               ));
//             } else if (state is CalenderSucces) {
//               WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
//                     isCalendarLoaded = true;
//                   }));
//               return DayViewPage(
//                 date: ValueNotifier(DateTime.now()),
//                 studentProfile: widget.studentProfile,
//                 // schedules: state.obj,
//                 // blackoutDate: state.obj1,
//               );
//             } else if (state is CalenderError) {
//               return NoDataFoundErrorWidget(
//                   isScheduleFound: true,
//                   isResultNotFoundMsg: false,
//                   isNews: false,
//                   isEvents: false);
//             }
//             return Container();
//           }),
//     );
//   }
// }
