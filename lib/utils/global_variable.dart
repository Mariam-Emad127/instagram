
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nstagram/presentation/screen/add_post_screen.dart';
import 'package:nstagram/presentation/screen/feed_screen.dart';
import 'package:nstagram/presentation/screen/profile_screen.dart';
import 'package:nstagram/presentation/screen/search_screen.dart';

List<Widget> homeScreenItems = [ 
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text("user. ")),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,
  //  postid: FirebaseFirestore.instance.collection( "post").doc("postId").get(),
  )
              ];