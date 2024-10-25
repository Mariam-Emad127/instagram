import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nstagram/presentation/auth/login.dart';
import 'package:nstagram/presentation/controller/auth_cubit.dart';
import 'package:nstagram/presentation/controller/auth_state.dart';
import 'package:nstagram/presentation/widget/text_field_input.dart';
import 'package:nstagram/utils/color.dart';
import 'package:nstagram/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List ?image;


    selectImage() async {
   Uint8List im= await pickImage(ImageSource.gallery);
   setState(() {
     image=im;
   });
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await AuthCubit().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: image!);
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
    }
    else {
      setState(() {
        _isLoading = false;
      });

    }}
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: primaryColor,
                      height: 64,
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    Stack(
                      children: [
                        image != null
                          ?
                        
                             CircleAvatar(
                                 radius: 64,
                                 backgroundImage: MemoryImage(image!),
                                 backgroundColor: Colors.red,
                               )
                             :
                             
                        const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo),
                           // onPressed: () {},
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your username',
                      textInputType: TextInputType.text,
                      textEditingController: _usernameController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                      isPass: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your bio',
                      textInputType: TextInputType.text,
                      textEditingController: _bioController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                       onTap: signUpUser,
                      // onTap: (){
                      //   BlocProvider.of<AuthCubit>(context).createUserWithEmailAndPassword(
                      //     email:  _emailController.text,password: _passwordController.text,
                      //     username: _usernameController.text, bio: _bioController.text, file: image!  );},
                      //

                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: blueColor,
                        ),
                        child:
                             !_isLoading
                              ?
                             const Text(  'Sign up',)
                            :
                            const CircularProgressIndicator(    color: primaryColor,  ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            'Already have an account?',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              ' Login.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

