import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/storage_methods.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up user
  Future<String>signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async{
    String res = "Some error occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty || bio.isNotEmpty || file != null){
        //reg user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);
        //add user to db
        _firestore.collection("users").doc(cred.user!.uid).set({
          "username": userName,
          "uid": cred.user!.uid,
          "email": email,
          "bio": bio,
          // "profile_image": file,
          "followers": [],
          "following": [],
          "photoUrl": photoUrl,
        });

        // alt method
        // await _firestore.collection("users").add({
        //   "username": userName,
        //   "uid": cred.user!.uid,
        //   "email": email,
        //   "bio": bio,
        //   "profile_image": file,
        //   "followers": [],
        //   "following": [],
        // });

        res = "Success";

      } 
    } on FirebaseAuthException catch (e){
      if(e.code == 'invalid-email'){
        res = 'The email address is badly formatted.';
      } else if(e.code == 'weak-password'){
        res = 'The password is too weak.';
      } else if(e.code == 'email-already-in-use'){
        res = 'The email address is already in use by another account.';
      } else if(e.code == 'operation-not-allowed'){
        res = 'Password sign-in is disabled for this project.';
      } else if(e.code == 'requires-recent-login'){
        res = 'This operation is sensitive and requires recent authentication. Log in again before retrying this request.';
      } else{
        res = 'An undefined error occured';
      }
    }
    catch(e){
      res = e.toString();
    }
    return res;
  }
}