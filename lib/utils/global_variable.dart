
import 'package:flutter/material.dart';
import 'package:nstagram/presentation/screen/add_post_screen.dart';
import 'package:nstagram/presentation/screen/feed_screen.dart';

List<Widget> homeScreenItems = [ 
  FeedScreen(),
  AddPostScreen(),
  Center(child: Text("user.email"),),
  
            Center(child: Text("user. ")),
              Center(child: Text(" .email"))
              ];