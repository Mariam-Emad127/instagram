import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nstagram/presentation/auth/login.dart';
import 'package:nstagram/provider/user_provider.dart';
import 'package:nstagram/responsive/%20mobile_screen_layout.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
void main()async { 
   WidgetsFlutterBinding.ensureInitialized();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize the Firebase app
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );

   runApp(const MyApp());

   
   }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
       
     child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        //darkTheme: Dar,
        //theme: ThemeData(
         //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //useMaterial3: true, ),
        theme: ThemeData.dark(),
        home:StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(),
            builder:(context,snapshot){
          if (snapshot.connectionState == ConnectionState.active) {
          if(snapshot.hasData){
      
          //  return LoginScreen();
           MobileScreenLayout();
          }
          else if (snapshot.hasError) {
      return Center(
      child: Text('${snapshot.error}'),
      );
      }}
      // means connection to future hasnt been made yet
         if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
      child: CircularProgressIndicator(),
      );
      
      }
          return const LoginScreen();
        },
        ),
        //LoginScreen()
      )
    );
  }
}

 