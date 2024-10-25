import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nstagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FireStoreMethods {
  FirebaseFirestore  firebaseFirestore=FirebaseFirestore.instance;
  Future<String>uploadPost(String description, Uint8List file, String uid,
      String username, String profImage)async{
    String res = "Some error occurred";
try{
  String photoUrl=await StorageMethods().uploadImageToStorage( "post", file, true);
String postId=Uuid().v1();
  Post post=Post(
  description: description,
  uid: uid,
  username: username,
  likes: [],
  postId: postId,
  datePublished: DateTime.now(),
  postUrl: photoUrl,
  profImage: profImage,);
  firebaseFirestore.collection( "post").doc(postId).set(post.toJson());
  res="sucess";
}catch(e){}


    return res;
  }


}