import 'dart:io';
import 'package:Soc/firebase_options.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/db_service_response.model.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static User? user;
  static const List<String> scopes = <String>[
    "profile",
    "email",
    // "https://www.googleapis.com/auth/drive",
    "https://www.googleapis.com/auth/drive.file",
    "https://www.googleapis.com/auth/classroom.courses",
    "https://www.googleapis.com/auth/classroom.rosters",
    "https://www.googleapis.com/auth/classroom.coursework.students",
    "https://www.googleapis.com/auth/userinfo.profile",
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/classroom.profile.emails",
    "https://www.googleapis.com/auth/classroom.profile.photos"
  ];

  /* -------------------------------------------------------------------------------------- */
  /* ------------------------------------initializeFirebase-------------------------------- */
  /* -------------------------------------------------------------------------------------- */
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => UserInfoScreen(
      //       user: user,
      //     ),
      //   ),
      // );
    }

    return firebaseApp;
  }

  /* -------------------------------------------------------------------------------------- */
  /* ---------------------------------------refreshToken----------------------------------- */
  /* -------------------------------------------------------------------------------------- */
  static Future<String> refreshToken() async {
    print("Token Refresh");
    final GoogleSignIn googleSignIn = await GoogleSignIn(
        clientId: Platform.isIOS
            ? DefaultFirebaseOptions.currentPlatform.iosClientId ?? ''
            : DefaultFirebaseOptions.currentPlatform.androidClientId ?? '',
        // forceCodeForRefreshToken: true,
        scopes: scopes);

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signInSilently(reAuthenticate: true);
    List<UserInformation> userInfo = await UserGoogleProfile.getUserProfile();
    if (googleSignInAccount == null) {
      await signInWithGoogle(userType: userInfo[0].userType ?? '');

      return userInfo.length < 1 ? '' : userInfo[0].authorizationToken ?? '';
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      AdditionalUserInfo additionalUserInfo =
          userCredential.additionalUserInfo!;
      user = userCredential.user;
      // Retrieve the refresh token
      // Access the refresh token from the UserCredential
      final String? refreshToken = userCredential.user!.refreshToken!;

      if (refreshToken != null) {
        // Use the refresh token as needed
        print('Refresh token: $refreshToken');
      } else {
        print('Refresh token not available');
      }

      //-------------------------------Updating user info locally--------------------------------------------
      await saveUserProfile(user!, googleSignInAuthentication,
          userInfo[0].userType ?? '', additionalUserInfo);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // Handle the case where the user already exists with a different credential
        // You can prompt the user to sign in with a different method or link their accounts.
        print('An account already exists with a different credential.');
      } else if (e.code == 'invalid-credential') {
        // Handle the case where the credential is invalid or expired
        print('Invalid credential.');
      } else {
        // Handle other FirebaseAuthException error codes
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
      }
    } catch (e) {
      // ...
    }
    print('Access Token:  ${googleSignInAuthentication.accessToken}');
    print('Refresh Token: ${user!.refreshToken!}');
    return googleSignInAuthentication.accessToken!; // New refreshed token
  }

  /* -------------------------------------------------------------------------------------- */
  /* -----------------------------------------signInWithGoogle-------------------------------------- */
  /* -------------------------------------------------------------------------------------- */
  static Future<User?> signInWithGoogle({required String userType}) async {
    // FirebaseAuth auth = FirebaseAuth.instance;
    // User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      //clientId: DefaultFirebaseOptions.currentPlatform.iosClientId
      final GoogleSignIn googleSignIn = await GoogleSignIn(
          clientId: Platform.isIOS
              ? DefaultFirebaseOptions.currentPlatform.iosClientId
              : DefaultFirebaseOptions.currentPlatform.androidClientId ?? '',
          // forceCodeForRefreshToken: true,
          scopes: scopes);

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      //---------------------------------------------------------------------------
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        print('Google Auth Call Details');
        print(googleSignInAuthentication.accessToken);
        print(googleSignInAuthentication.idToken);

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        print(googleSignInAuthentication.accessToken);
        try {
          print('Google Auth Credentials::::::: $credential');
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);
          AdditionalUserInfo userDetails =
              userCredential.additionalUserInfo!; //
          print('Google Auth Additional Info::::::: $userDetails');
          user = userCredential.user;
          print('Google Auth User::::::: ${userDetails.profile}');
          // Retrieve the refresh token
          // Access the refresh token from the UserCredential
          final String? refreshToken = userCredential.user!.refreshToken;

          if (refreshToken != null) {
            // Use the refresh token as needed
            print('Refresh token: $refreshToken');
          } else {
            print('Refresh token not available');
          }

          //-------------------------------Updating user info locally--------------------------------------------

          await saveUserProfile(
              user!, googleSignInAuthentication, userType, userDetails);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // Handle the case where the user already exists with a different credential
            // You can prompt the user to sign in with a different method or link their accounts.
            print('An account already exists with a different credential.');
          } else if (e.code == 'invalid-credential') {
            // Handle the case where the credential is invalid or expired
            print('Invalid credential.');
          } else {
            // Handle other FirebaseAuthException error codes
            print('Error code: ${e.code}');
            print('Error message: ${e.message}');
          }
        } catch (e) {
          // ...
        }
      }
    }

    return user;
  }

  /* -------------------------------------------------------------------------------------- */
  /* -----------------------------------------signOut-------------------------------------- */
  /* -------------------------------------------------------------------------------------- */
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS
            ? DefaultFirebaseOptions.currentPlatform.iosClientId ?? ''
            : DefaultFirebaseOptions.currentPlatform.androidClientId ?? '',
        // forceCodeForRefreshToken: true,
        scopes: scopes);

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await googleSignIn.signOut();
      user = null;
    } catch (e) {
      print('Sign Out Error:::::: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  /* -------------------------------------------------------------------------------------- */
  /* --------------------------------------saveUserProfile---------------------------------- */
  /* -------------------------------------------------------------------------------------- */
  static Future<void> saveUserProfile(
      User user,
      GoogleSignInAuthentication googleSignInAuthentication,
      String userType,
      AdditionalUserInfo additionalUserInfo) async {
    // LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    //clear the existing data
    await UserGoogleProfile.clearUserProfile();
    UserInformation _userInformation = UserInformation(
        userName: user.displayName,
        userEmail: user.email,
        profilePicture:
            additionalUserInfo.profile!["picture"], // user.photoURL,
        authorizationToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
        refreshToken: user.refreshToken ?? "",
        userType: userType);

    //Save user profile to locally
    //UPDATE CURRENT GOOGLE USER PROFILE
    await UserGoogleProfile.updateUserProfile(_userInformation);
    // await _localDb.close();
  }
  /* -------------------------------------------------------------------------------------- */
  /* --------------------------------------customSnackBar---------------------------------- */
  /* -------------------------------------------------------------------------------------- */

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future refreshAuthenticationToken({String? refreshToken}) async {
    var result;
    if (Globals.appSetting.enableGoogleSSO != "true" || Globals.appSetting.enableGoogleSSO == "true" ) {
      result = await _toRefreshAuthenticationToken(refreshToken ?? '');
    } else {
      result = await Authentication.refreshToken();
    }
    return result;
  }

  static Future<bool> _toRefreshAuthenticationToken(String refreshToken) async {
    try {
      final DbServices _dbServices = DbServices();
      final body = {"refreshToken": refreshToken};
      final ResponseModel response = await _dbServices.postApi(
          "${OcrOverrides.OCR_API_BASE_URL}/refreshGoogleAuthentication",
          body: body,
          isGoogleApi: true);
      if (response.statusCode != 401 &&
          response.statusCode == 200 &&
          response.data['statusCode'] != 500) {
        var newToken = response.data['body']; //["access_token"]
        //!=null?response.data['body']["access_token"]:response.data['body']["error"];
        if (newToken["access_token"] != null) {
          List<UserInformation> _userProfileLocalData =
              await UserGoogleProfile.getUserProfile();

          UserInformation updatedObj = UserInformation(
              userName: _userProfileLocalData[0].userName,
              userEmail: _userProfileLocalData[0].userEmail,
              profilePicture: _userProfileLocalData[0].profilePicture,
              userType: _userProfileLocalData[0].userType,
              refreshToken: _userProfileLocalData[0].refreshToken,
              authorizationToken: newToken["access_token"]);

          // await UserGoogleProfile.updateUserProfileIntoDB(updatedObj);

          await (updatedObj);

          //  await HiveDbServices().updateListData('user_profile', 0, updatedObj);

          return true;
        } else {
          return false;
        }
      } else {
        return false;
        //  throw ('something_went_wrong');
      }
    } catch (e) {
      //print(" errrrror  ");
      print(e);
      throw (e);
    }
  }

  static Future reAuthenticationRequired(
      {required String errorMessage,
      required BuildContext context,
      required GlobalKey<State<StatefulWidget>>? scaffoldKey}) async {
    if (Globals.appSetting.enableGoogleSSO != "true") {
      await Utility.refreshAuthenticationToken(
          isNavigator: false,
          errorMsg: errorMessage,
          context: context,
          scaffoldKey: scaffoldKey);
    } else {
      await Authentication.refreshToken();
    }
  }
}
