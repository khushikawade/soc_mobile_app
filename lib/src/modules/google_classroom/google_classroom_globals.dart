import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';

import 'modal/google_classroom_courses.dart';

class GoogleClassroomGlobals {
  //Contains course detail for select course // single object only to use everywhere in the app
  static GoogleClassroomCourses studentAssessmentAndClassroomObj =
      GoogleClassroomCourses();
  static ClassroomCourse studentAssessmentAndClassroomAssignmentForStandardApp =
      ClassroomCourse();

  static ClassroomCourse
      studentAssessmentAndClassroomHistoryAssignmentForStandardApp =
      ClassroomCourse();
}
