import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import '../modal/google_classroom_courses.dart';

class GoogleClassroomOverrides {
  //Contains course detail for select course // single object only to use everywhere in the app
  static GoogleClassroomCourses studentAssessmentAndClassroomObj =
      GoogleClassroomCourses();

  //Used at new result summary screen
  static ClassroomCourse recentStudentResultSummaryForStandardApp =
      ClassroomCourse();

//Used at history result summary screen
  static ClassroomCourse historyStudentResultSummaryForStandardApp =
      ClassroomCourse();
}
