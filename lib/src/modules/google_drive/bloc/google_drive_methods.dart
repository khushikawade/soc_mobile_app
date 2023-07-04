import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/services/user_profile.dart';

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

  Future<bool> getAndUpdateFolderDetails({required String folderName}) async {
    try {
      GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();
      List<UserInformation> _userProfileLocalData =
          await UserGoogleProfile.getUserProfile();
      UserInformation userProfileLocalInfo = _userProfileLocalData[0];

      //Get Folder Id if folder already exist
      var folderObject = await googleDriveBloc.getGoogleDriveFolderId(
          token: userProfileLocalInfo.authorizationToken, // event.token,
          folderName: folderName,
          refreshToken:
              userProfileLocalInfo.refreshToken); // event.refreshToken);

      if (folderObject != 401 && folderObject != 500) {
        print("inside folder obj::::::${folderObject}");
        //Which means folder API return 200 but folder not found
        if (folderObject.length == 0) {
          print("${folderName} is not available on drive Create one ");
          //Create the folder now
          List isFolderCreated = await googleDriveBloc.createFolderOnDrive(
              token: userProfileLocalInfo.authorizationToken,
              folderName: folderName);

          if (isFolderCreated[0] == true) {
            bool result = await updateDriveFolderDetails(
                isFolderCreated[0], userProfileLocalInfo, folderName);
            return result;
          } else {
            return false;
          }
        } else {
          bool result = await updateDriveFolderDetails(
              folderObject, userProfileLocalInfo, folderName);
          return result;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future updateDriveFolderDetails(folderObject,
      UserInformation userProfileLocalInfo, String folderName) async {
    print("FOLDER IS ALREADY EXISTS SECTION NAME ${folderName} ");

    if (folderName == "SOLVED GRADED+") {
      userProfileLocalInfo.gradedPlusGoogleDriveFolderId = folderObject['id'];
      userProfileLocalInfo.gradedPlusGoogleDriveFolderPathUrl =
          folderObject['webViewLink'];
    } else if (folderName == "SOLVED PBIS+") {
      userProfileLocalInfo.pbisPlusGoogleDriveFolderId = folderObject['id'];
    } else if (folderName == "SOLVED STUDENT+") {
      userProfileLocalInfo.studentPlusGoogleDriveFolderId = folderObject['id'];
    }

    // Update Details in localDb
    await UserGoogleProfile.updateUserProfile(userProfileLocalInfo);
    return true;
  }
}
