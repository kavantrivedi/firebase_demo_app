import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class AuthService {
  Future<String?> registration({
    required String email,
    required String password,
    required UserModel userModel,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) =>
      {
        postDetailsToFirestore(
          userModel: userModel,
        )
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      } else {
        debugPrint(e.message);
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  void postDetailsToFirestore({
    required UserModel userModel,
  }) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    userModel.uid = user?.uid;
    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .set(userModel.toMap());
  }
}
