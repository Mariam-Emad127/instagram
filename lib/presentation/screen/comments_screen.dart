import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nstagram/models/user.dart';
import 'package:nstagram/presentation/widget/comment_card.dart';
import 'package:nstagram/provider/user_provider.dart';
import 'package:nstagram/resources/firestore_methods.dart';
import 'package:nstagram/utils/color.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;

  const CommentsScreen({super.key, required this.snap});
  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text(
            'Comments',
          ),
          //centerTitle: false,
        ),
        body: //CommentCard(),

           StreamBuilder (
             //widget.snap["postId"]
          stream:FirebaseFirestore.instance.collection("post").doc(widget.snap).collection( "comment").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }


            return ListView.builder(
              itemCount: (snapshot.data as dynamic) .docs.length,
                 itemBuilder: (BuildContext context, int index) {

                   return  CommentCard( snap: snapshot.data!.docs[index],); },
// snap: snapshot.data!.docs[index],
            );
          }
        ),

        bottomNavigationBar: SafeArea(
            child: Container(
                height: kToolbarHeight,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.photoUrl,
                    ),
                    //"https://images.unsplash.com/photo-1729027399111-e301fa0e14fa?q=
                    // 80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                    radius: 18,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: TextField(
                        controller: commentEditingController,
                        decoration: InputDecoration(
                          hintText: 'Comment as ${user.username}',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () async {
                      await FireStoreMethods().postComment(
                         // widget.snap["postId"].toString(),
                          widget.snap,
                          commentEditingController.text,
                          // widget.snap["text"],
                          user.uid,
                          user.username,
                          user.photoUrl);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: const Text(
                        'Post',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                

                ]))));
  }
}
