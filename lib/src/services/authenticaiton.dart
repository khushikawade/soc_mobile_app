import 'dart:io';

import 'package:Soc/firebase_options.dart';
import 'package:Soc/src/modules/auth_dummy/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  /* -------------------------------------------------------------------------------------- */
  /* ------------------------------------initializeFirebase-------------------------------- */
  /* -------------------------------------------------------------------------------------- */
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserInfoScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  /* -------------------------------------------------------------------------------------- */
  /* -------------------------------------signInWithGoogle--------------------------------- */
  /* -------------------------------------------------------------------------------------- */

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];
    User? user;

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
      final GoogleSignIn googleSignIn =
          GoogleSignIn(forceCodeForRefreshToken: true);

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
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
