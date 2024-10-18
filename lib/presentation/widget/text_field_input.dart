import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({super.key,
   required this.hintText,
    required this.textInputType, 
      this.isPass=false, 
    required this.textEditingController});
final String hintText;
final TextInputType textInputType;
final bool isPass;
final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
final inputBorder=OutlineInputBorder(borderSide: Divider.createBorderSide(context));



    return  TextField(
controller: textEditingController,
 
decoration: InputDecoration(
  hintText: hintText,
border: inputBorder,
  focusedBorder: inputBorder,
  filled: true,
  contentPadding: EdgeInsets.all(8)
  
  ),
keyboardType: textInputType,
obscureText: isPass,



    );
  }
}