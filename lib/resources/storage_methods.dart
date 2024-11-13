import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:nstagram/models/user.dart'as model;
import 'package:uuid/uuid.dart';

class StorageMethods {

FirebaseStorage storage=FirebaseStorage.instance;
FirebaseAuth _auth=FirebaseAuth.instance;

Future<String> uploadImageToStorage(String childname,Uint8List file,bool isPost )async{
 final time=DateTime.now().microsecondsSinceEpoch;
  // creating location to our firebase storage
Reference reference=
FirebaseStorage.instance.ref().child("childname/$time").child(FirebaseAuth.instance.currentUser!.uid);//.putData(file);


if(isPost){
  String id =Uuid().v4();
  reference.child(id);
}
UploadTask uploadTask=reference.putData(file);
TaskSnapshot snapshot=await uploadTask;

String downloadUrl=await snapshot.ref.getDownloadURL();
return downloadUrl;
//return url;

}

Future<model.User>getUserDetails()async{

 User currentUser =await _auth.currentUser!;
DocumentSnapshot snap=await 
FirebaseFirestore.instance.collection( "users").doc(currentUser.uid).get();

return model.User.fromSnap(
  snap
//return snap.data() as Map<String,dynamic>;
  //email:(snap.data() as Map<String,dynamic>)["email"],  
   
  );
}
 Future<List<Reference>?>getFile()async{
  try{
final storageref=FirebaseStorage.instance.ref();
final uploadstorage=storageref.child("post");
  final uploads= await uploadstorage.listAll();
  return uploads.items;
  }
  catch(e){print(e); }

 }
}

 