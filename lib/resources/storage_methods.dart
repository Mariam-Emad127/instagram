import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:nstagram/models/user.dart'as model;
import 'package:uuid/uuid.dart';

class StorageMethods {

FirebaseStorage storage=FirebaseStorage.instance;
FirebaseAuth _auth=FirebaseAuth.instance;

Future<String>uploadImageToStorage(String childname,Uint8List file,bool isPost )async{
   // creating location to our firebase storage

Reference reference=FirebaseStorage.instance.ref().child(childname).child(FirebaseAuth.instance.currentUser!.uid);
if(isPost){
  String id =Uuid().v1();
  reference.child(id);


}
UploadTask uploadTask=reference.putData(file);
TaskSnapshot snapshot=await uploadTask;

String downloadUrl=await snapshot.ref.getDownloadURL();

return downloadUrl;
}


Future<model.User>getUserDetails()async{
 User currentUser =_auth.currentUser!;
DocumentSnapshot snap=await 
//FirebaseAuth.instance.
FirebaseFirestore.instance.collection( "users").doc(currentUser.uid).get();

//return snap.data() as Map<String,dynamic>; 
return model.User.fromSnap(
  snap
  
  //email:(snap.data() as Map<String,dynamic>)["email"],  
   
  );
}
 
}

 