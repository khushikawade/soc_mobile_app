import 'dart:io';

import 'package:Soc/firebase_options.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
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
    "https://www.googleapis.com/auth/drive",
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
        forceCodeForRefreshToken: true,
        scopes: scopes);

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signInSilently();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

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
      saveUserProfile(user!, googleSignInAuthentication);
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
  static Future<User?> signInWithGoogle() async {
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
              : DefaultFirebaseOptions.currentPlatform.androidClientId ??
                '',
          forceCodeForRefreshToken: true,
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

          user = userCredential.user;
          print('Google Auth User::::::: $user');
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

          saveUserProfile(user!, googleSignInAuthentication);
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
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      user = null;
    } catch (e) {
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
      User user, GoogleSignInAuthentication googleSignInAuthentication) async {
    // List<String> profile = profileData.split('+');
    UserInformation _userInformation = UserInformation(
        userName: user.displayName,
        userEmail: user.email,
        profilePicture: user.photoURL,
        authorizationToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
        refreshToken: user.refreshToken ?? "");

    //Save user profile to locally
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    await _localDb.addData(_userInformation);
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
}
