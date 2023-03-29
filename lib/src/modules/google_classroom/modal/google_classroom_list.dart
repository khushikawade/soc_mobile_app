import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/services/strings.dart';

import '../../../services/local_database/local_db.dart';
import '../../ocr/modal/user_info.dart';

class GoogleClassroom {
  static Future<List<GoogleClassroomCourses>> getGoogleClassroom() async {
    LocalDatabase<GoogleClassroomCourses> _gClassroom =
        LocalDatabase(Strings.googleClassroomCoursesList);

    List<GoogleClassroomCourses>? _gClassroomList = await _gClassroom.getData();

    // if (_gClassroomList.isNotEmpty) {}

    try {
      await _gClassroom.close();
    } catch (e) {
      print(e);
    }

    sort(obj: _gClassroomList);
    return _gClassroomList;
  }

  static Future<void> clearClassroomCourses() async {
    try {
      LocalDatabase<GoogleClassroomCourses> _localDb =
          LocalDatabase(Strings.googleClassroomCoursesList);
      await _localDb.clear();
    } catch (e) {
      return;
    }
  }

  static Future<void> updateUserProfile(gClassroom) async {
    await clearClassroomCourses();
    LocalDatabase<UserInformation> _localDb =
        LocalDatabase(Strings.googleClassroomCoursesList);
    await _localDb.addData(gClassroom);
    await _localDb.close();
  }

  static void sort({required List<GoogleClassroomCourses> obj}) {
    obj.sort((a, b) => a.name!.compareTo(b.name!));
    try {
      for (int i = 0; i < obj.length; i++) {
        if (obj[i].studentList!.length > 0) {
          obj[i].studentList!.sort((a, b) => a['profile']['name']['givenName']!
              .toString()
              .toUpperCase()
              .compareTo(
                  b['profile']['name']['givenName']!.toString().toUpperCase()));
        }
      }
    } catch (e) {}
  }
}
