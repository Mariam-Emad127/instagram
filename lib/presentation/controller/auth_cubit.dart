import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nstagram/presentation/controller/auth_state.dart';
import 'package:nstagram/resources/storage_methods.dart';
import 'package:nstagram/models/user.dart' as model;
class AuthCubit extends Cubit<AuthState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthCubit() : super(AuthInitial());

  Future<String>  createUserWithEmailAndPassword({required String email,
  required String password, 
  required String username,
    required String bio,required Uint8List file
    })async {
  emit(AuthLoading());

String res="sucsess";
try {
 if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null
          ){
  
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  print(credential.user!.uid);
 String photoUrl= await StorageMethods().uploadImageToStorage("profile", file, false);
model.User user=model.User(   username: username,
    uid: credential.user!.uid,
    photoUrl: photoUrl,
    email: email,
    bio: bio,
    followers: [],
    following: [],);
await _firestore.collection( "users").doc(credential.user!.uid).set(
   // {
   //  "username":username,
   //  "uid":credential.user!.uid,
   //  "email": email,
   //  "bio": bio,
   //  "photoUrl":photoUrl,
   //  "followers": [],
   //  "following": [],
   //
   //
   //
   //  }
 user.toJson()
    );

  res = "success";
}} 
on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');

  }

emit(AuthSucess());
} catch (e) {
  emit(AuthError(e.toString()));
  print(e);
}
return res;
          }



 Future<String> SignInWithEmailAndPassword({required String email,required String password})async {
   String res = " sucsess";
  emit(AuthLoading());
try {
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword (
    email: email,
    password: password,
  );


emit(AuthSucess());
    res = "success";
} catch (e) {
  emit(AuthError(e.toString()));
  print(e);
  return e.toString();
}
  return res;
  }




Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }


}