// import 'dart:html';
// import 'package:googleapis/calendar/v3.dart';
// import 'package:googleapis_auth/auth_browser.dart' as auth;

// var id = new auth.ClientId("<yourID>", "<yourKey>");
// var scopes = [CalendarApi.CalendarScope];

// void main() {
//   auth
//       .createImplicitBrowserFlow(id, scopes)
//       .then((auth.BrowserOAuth2Flow flow) {
//     flow.clientViaUserConsent().then((auth.AuthClient client) {
//       var calendar = new CalendarApi(client);

//       String adminPanelCalendarId = 'primary';

//       var event = calendar.events;

//       var events = event.list(adminPanelCalendarId);

//       events.then((showEvents) {
//         showEvents.items.forEach((Event ev) {
//           print(ev.summary);
//         });
//         querySelector("#text2").text = showEvents.toString();
//       });

//       client.close();
//       flow.close();
//     });
//   });
// }
