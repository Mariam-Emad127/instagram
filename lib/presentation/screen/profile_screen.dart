import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../resources/firestore_methods.dart';
import '../../resources/storage_methods.dart';
import '../../utils/color.dart';
import '../../utils/utils.dart';
import '../widget/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
 // final dynamic postid;
  const ProfileScreen({super.key, required this.uid });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  //String postUrl="";
  List<Reference> file = [];


  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

    //  postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      String postUrl = userSnap.data()!["postUrl"];
      followers = userSnap.data()!["followers"];
      following = userSnap.data()!["following"];
      print(postUrl);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        :

      Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(
            userData['username'],
          ),
          centerTitle: false,
        ),
        body: ListView(

            children: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(

                  children: [
                Row(

                    children: [

                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      userData['photoUrl'],
                    ),
                    radius: 40,
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatColumn(postLen, "posts"),
                            buildStatColumn(followers, "followers"),
                            buildStatColumn(following, "following"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? FollowButton(
                                    text: 'Edit profile',
                                    backgroundColor: mobileBackgroundColor,
                                    textColor: primaryColor,
                                    borderColor: Colors.grey,
                                    function: () async {})
                                : isFollowing
                                    ? FollowButton(
                                        text: 'unFollow',
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          await FireStoreMethods()
                                            .followUser(
                                            FirebaseAuth.instance
                                                .currentUser!.uid,
                                            userData['uid'],);
                                          setState(() {
                                            isFollowing = false;
                                            followers--;
                                          });
                                        }
                            )

                                    :
                            FollowButton(
                                        text: 'Follow',
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        borderColor: Colors.grey,
                                        function: () async { await FireStoreMethods()
                                            .followUser(
                                          FirebaseAuth.instance
                                              .currentUser!.uid,
                                          userData['uid'],);
                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                        })
                          ],
                        )
                      ]))
                ]),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: Text(
                    userData["username"],
                    //'username',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 1,
                  ),
                  child: Text(
                    userData['bio'],
                  ),
                ),


                const Divider(),
                FutureBuilder(
                 //   future: Future.delayed(Duration(milliseconds:40 )),
                future:FirebaseFirestore.instance
        .collection('post')
        .where('uid', isEqualTo: widget.uid)
        .get(),
                    //Future.delayed(Duration(milliseconds:40 ) ),

     builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        itemCount: (snapshot.data! as dynamic).docs.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 1.5,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
           DocumentSnapshot snap =( snapshot.data!).docs[index];

          return SizedBox(

            child: Image(
              image: NetworkImage( (snap['postUrl'].toString())?? "https://firebasestorage.googleapis.com/v0/b/insta-5105f.appspot.com/o/post%2F3wCdEVlNzTX8dY9ZuRywVnjfekf2?alt=media&token=efda48e7-eddf-4241-9834-698069695224"  ),

              fit: BoxFit.cover,
            ),
          );
        },

      );
    })


              ]))
        ]));
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  void uploaded() async {
    List<Reference>?result=await StorageMethods().getFile();
    if(result!= null){

      setState(() {
        file=result;
      });
    }

  }


}
