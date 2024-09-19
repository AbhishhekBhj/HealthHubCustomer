import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthhubcustomer/View/widgets/alerts/custom_snackbar.dart';
import 'package:healthhubcustomer/colors/colors.dart';

Future<UserCredential?> signInWithGoogle({required BuildContext context}) async {
  log("Google Sign In Clicked");
  try {
    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

    if (googleSignInAccount == null) return null;

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

    return userCredential;
  } on PlatformException catch (e) {
    if (e.code == 'popup_closed_by_user') {
      log('Google sign-in canceled by user');
    } else if (e.code == 'sign_in_failed') {
      log('Google sign-in failed: ${e.message}');
    } else {
      log('Platform exception: ${e.message}');
    }
  } catch (e) {

   customSnackBar(context:context , message: e.toString(), snackBarColor: appErrorColor, textColor: appWhiteColor);

    log('Unexpected error: $e');
    rethrow;
  }
  return null;
}

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }