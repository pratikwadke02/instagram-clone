import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/models/user.dart' as model;

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

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

        model.User _user = model.User(
          email: email,
          username: userName,
          bio: bio,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          followers: [],
          following: [],
        );

        await _firestore
        .collection("users")
        .doc(cred.user!.uid)
        .set(_user.toJson());

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

      } else {
        res = "Please fill all the fields";
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
      return e.toString();
    }
    return res;
  }

  //sign in user
  Future<String> logInUser({
    required String email,
    required String password,
  })async{
    String res = "Some error occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(
          email: email, 
          password: password
          );
        res = "Success";
      }else{
        res = "Please enter email and password";
      }
    }on FirebaseAuthException catch (e){
      if(e.code == 'invalid-email'){
        res = 'The email address is badly formatted.';
      } else if(e.code == 'user-not-found'){
        res = 'There is no user record corresponding to this identifier. The user may have been deleted.';
      } else if(e.code == 'wrong-password'){
        res = 'The password is invalid or the user does not have a password.';
      } else if(e.code == 'user-disabled'){
        res = 'The user account has been disabled by an administrator.';
      } else if(e.code == 'too-many-requests'){
        res = 'Too many unsuccessful login attempts.  Please try again later.';
      } else if(e.code == 'operation-not-allowed'){
        res = 'Password sign-in is disabled for this project.';
      } else if(e.code == 'requires-recent-login'){
        res = 'This operation is sensitive and requires recent authentication. Log in again before retrying this request.';
      } else{
        res = 'An undefined error occured';
      }
    }
    catch(e){
      return e.toString();
    }
    return res;
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }


}