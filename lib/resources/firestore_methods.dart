import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nstagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';

class FireStoreMethods {


  FirebaseFirestore  firebaseFirestore=FirebaseFirestore.instance;


  Future<String> uploadPost(String description, Uint8List file, String uid, String username, String profImage )async
  {
    String res = "Some error occurred";
try{
var photoUrl=await StorageMethods().uploadImageToStorage( "post", file, true);
String postId=Uuid().v4();
  Post post=Post(
  description: description,
  uid: uid,
  username: username,
  likes: [],
  postId: postId,
  datePublished: DateTime.now(),
  postUrl: photoUrl,
  profImage: profImage,

  );
  firebaseFirestore.collection( "post").doc(postId).set(post.toJson());
  res="sucess";
}catch(e){print(e.toString());}


    return res;
  }


  Future<String> likePost(String postId,String uid,List likes  )async{
    String res = "Some error occurred";
    try{
if(likes.contains(uid)){

      FirebaseFirestore.instance.collection("post").doc(postId).update( {"likes":FieldValue.arrayRemove( [uid])});

}else{
      FirebaseFirestore.instance.collection("post").doc(postId).update( {"likes":FieldValue.arrayUnion( [uid])});

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

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await FirebaseFirestore.instance.collection('post').doc(postId).delete();


      res = 'success';
      print("kkkkkkkkkkkkkkkkkkkkkkkkkk");
      print(res);
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await   FirebaseFirestore.instance.collection('users').doc(uid).get();
      List following= (snap.data() as dynamic)["following"];
      if(following.contains(followId)){
await  FirebaseFirestore.instance.collection('users').doc(uid).update( {
  
  "following":FieldValue.arrayRemove([uid])
});

await  FirebaseFirestore.instance.collection('users').doc(uid).update({
  'following': FieldValue.arrayRemove([followId])
});
      } else {
        await  FirebaseFirestore.instance.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await  FirebaseFirestore.instance.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([followId])
        });
      }

    }catch(e){
      print(e.toString());}



  }
}