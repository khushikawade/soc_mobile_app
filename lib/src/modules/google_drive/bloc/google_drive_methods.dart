import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';

class GoogleDriveBlocMethods {
  List<ClassroomCourse> updateSheetTabTitleForDuplicateNames(
      {required final List<ClassroomCourse> allCourses}) {
    try {
      // Managing the local list to make sure no record skip //Noticed sometime
      List<ClassroomCourse> localAllCourses = [];
      localAllCourses.addAll(allCourses);

      //Storing each course name in key-value pair to update the name of any duplicate course name
      Map<String, int> courseCount = {};
      List<ClassroomCourse> duplicateCourseListWithUpdatedTitle = [];

      for (ClassroomCourse course in localAllCourses) {
        String courseName = course.name ?? '';
        //check if course already present or not
        if (courseCount.containsKey(courseName)) {
          //get old count and update with new value
          int count = courseCount[courseName]! + 1;
          courseCount[courseName] = count; // update on courseCount
          //update the key with latest count
          courseName = '${courseName}_$count';
        } else {
          courseCount[courseName] = 0; // update with default count
        }

        //update the new list with updated news
        duplicateCourseListWithUpdatedTitle.add(ClassroomCourse(
          id: course.id,
          name: courseName, // Use the updated courseName value
          descriptionHeading: course.descriptionHeading,
          ownerId: course.ownerId,
          enrollmentCode: course.enrollmentCode,
          courseState: course.courseState,
          students: course.students,
        ));
      }

      return duplicateCourseListWithUpdatedTitle;
    } catch (e) {
      throw (e);
    }
  }
}
