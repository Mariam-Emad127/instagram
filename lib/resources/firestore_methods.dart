import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
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


  Future<String> likePost(String postId,String uid,List likes)async{
    String res = "Some error occurred";
    try{
if(likes.contains(uid)){

      FirebaseFirestore.instance.collection("post").doc(postId).update( {"like":FieldValue.arrayRemove( [uid])});

}else{
      FirebaseFirestore.instance.collection("post").doc(postId).update( {"like":FieldValue.arrayUnion( [uid])});
}
   res = 'success';
    }

catch(e){print(e);}
return res;
  }

 Future<String>postComment(String postId, String text, String uid,String name, String profilePic)async{
  String res = "Some error occurred";
try{
if(text.isNotEmpty){
   String commentId=const Uuid().v1();
await FirebaseFirestore.instance.collection( "post").doc(postId).collection("comment").doc(commentId).set( {
         'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
});
res = 'success';
}   
       else {
        res = "Please enter text";
      }
}catch(e){
print(e);
  res = e.toString();

}



return res;
 }



}