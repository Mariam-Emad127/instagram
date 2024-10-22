import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class StorageMethods {

FirebaseStorage storage=FirebaseStorage.instance;


Future<String>uploadImageToStorage(String childname,Uint8List file,bool isPost )async{
   // creating location to our firebase storage

Reference reference=FirebaseStorage.instance.ref().child(childname).child(FirebaseAuth.instance.currentUser!.uid);
UploadTask uploadTask=reference.putData(file);
TaskSnapshot snapshot=await uploadTask;

String downloadUrl=await snapshot.ref.getDownloadURL();

return downloadUrl;
}


}