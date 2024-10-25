import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source)async{
  final ImagePicker picker = ImagePicker();
XFile ?file=await  picker.pickImage(source: source);

if(file !=null){

  return await file.readAsBytes();
}
print( "no image selected");
}


// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}