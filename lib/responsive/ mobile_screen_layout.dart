import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nstagram/provider/user_provider.dart';
import 'package:nstagram/utils/global_variable.dart';
import 'package:provider/provider.dart';
import '../utils/color.dart';
import 'package:nstagram/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    addData();
    // getdata();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  //to fet data stored
  /*
void getdata()async{
DocumentSnapshot snap=await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
print("fffffffffffffffffffffffffffffffffffffffffffffffff");
print(snap.data());
/*    
setState(() {
 String username=(snap.data()as Map<String,dynamic>) ["username"];
});
*/
}
*/
  void addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    //model.User user = Provider.of<UserProvider>(context).getUser;

    return MaterialApp(

      //child:

       home: Scaffold(
        body: PageView(
          children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
        icon: Icon(
        Icons.home,
          color: (_page == 0) ? primaryColor : secondaryColor,
        ),
        label: '',
        backgroundColor: primaryColor,
      ),
      BottomNavigationBarItem(
      icon: Icon(
      Icons.search,
      color: (_page == 1) ? primaryColor : secondaryColor,

      ),
      label: '',
      backgroundColor: primaryColor),
      BottomNavigationBarItem(
      icon: Icon(
      Icons.add_circle,
      color: (_page == 2) ? primaryColor : secondaryColor,
      ),
      label: '',
      backgroundColor: primaryColor),
      BottomNavigationBarItem(
      icon: Icon(
      Icons.favorite,
      color: (_page == 3) ? primaryColor : secondaryColor,
      ),
      label: '',
      backgroundColor: primaryColor,
      ),
      BottomNavigationBarItem(
      icon: Icon(
      Icons.person,
      color: (_page == 4) ? primaryColor : secondaryColor,
      ),
      label: '',
      backgroundColor: primaryColor,
      ),


          ],

          onTap: navigationTapped,
           currentIndex: _page,
        ),
      ),
    );
  }
}
