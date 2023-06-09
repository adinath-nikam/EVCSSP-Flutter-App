import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evcssp/ShowSnackBar.dart';

import 'ModelProfileData.dart';
import 'SignInView.dart';
import 'TabView.dart';

class FirebaseAuthServices {
  User? get firebaseUser => firebaseAuth.currentUser;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  // EMAIL SIGNUP
  Future<void> signUpWithEmail(
      {required String email,
      required password,
      required BuildContext context}) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
      .then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>SignInView()));
      });
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "Entered Password is Weak", Colors.yellow);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'Account already Exists for this Email',
            Colors.yellow);
      } else {
        showSnackBar(context, e.message!, Colors.red);
      }
    }
  }

  // EMAIL LOGIN
  Future<void> signInWithEmail(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {

        // DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        // DatabaseEvent databaseEvent = await databaseReference
        //     .child(
        //     "EVCSSP/USERS_DATA/${firebaseAuthServices.firebaseUser?.uid}")
        //     .once();

          // if (databaseEvent.snapshot.value != null) {
          //   Map<dynamic, dynamic> temp =
          //   databaseEvent.snapshot.value as Map<dynamic, dynamic>;
          //
          //   ModelProfileData modelProfileData = ModelProfileData.fromJson(temp);
          //   // Navigator.pop(context);
          // } else {
          //   // Navigator.pop(context);
          // }

        Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>TabView()));

        //
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showSnackBar(context, e.message!, Colors.red);
    }
  }

  // SEND EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      firebaseAuth.currentUser!.sendEmailVerification();
      showSnackBar(context, "Email Verification Link is Sent to your Mail.",
          Colors.green);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, Colors.green);
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, Colors.red);
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, Colors.red);
    }
  }
}
