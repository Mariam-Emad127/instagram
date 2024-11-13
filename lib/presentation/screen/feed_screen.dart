import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nstagram/presentation/widget/post_card.dart';
import 'package:nstagram/utils/color.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset(
            "assets/ic_instagram.svg",
            color: primaryColor,
            height: 32,
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.message))]),
      body:

      StreamBuilder (
        stream:FirebaseFirestore.instance.collection("post").snapshots(),
         builder: (BuildContext context,  snapshot)  {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator( ),
            );
          }else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No posts available'),
            );
          }


    // return FutureBuilder(
    //
    // future: Future.delayed(Duration(milliseconds:10 )),
    //builder: (context, delaySnapshot) {
       if (snapshot.connectionState == ConnectionState.waiting&&snapshot.data==null){
    return const Center(child: CircularProgressIndicator(),);
    }
    if (snapshot.connectionState == ConnectionState.active&&snapshot!=null ) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) =>
              PostCard(
                snap: snapshot.data?.docs[index].data()  ,
              ),
        );
      }
    }

       return   Center(
         child: CircularProgressIndicator(),
       );
    }


      //);
          
          // PostCard();
       // },
 
      ),
    );
  }
}
