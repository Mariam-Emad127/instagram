import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nstagram/models/user.dart' as model;
import 'package:nstagram/presentation/screen/comments_screen.dart';
import 'package:nstagram/presentation/widget/comment_card.dart';
import 'package:nstagram/presentation/widget/like_animation.dart';
import 'package:nstagram/provider/user_provider.dart';
import 'package:nstagram/resources/firestore_methods.dart';
import 'package:nstagram/utils/color.dart';
import 'package:nstagram/utils/utils.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;

  PostCard({super.key, this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen=0;
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comment')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      child: Column(children: [
        // HEADER SECTION OF THE POST
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 16,
          ).copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(radius: 16, backgroundImage: NetworkImage(
                // "https://images.unsplash.com/photo-1729027399111-e301fa0e14fa?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                 //),
                widget.snap["profImage"]
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Column(children: [
                Text(
                  "kkk",
                  //widget.snap['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            )),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              InkWell(
                                  onTap: () {},
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text('Delete'))),
                            ]),
                      );
                    });
              },
              icon: const Icon(Icons.more_vert),
            )
          ]),
        ),
/*
        Stack(
alignment: Alignment.center,
         children:[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.snap["postUrl"],
             //  "https://images.unsplash.com/photo-1729027399111-e301fa0e14fa?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              fit: BoxFit.cover,
            ),
          ),
         ]
        ),
  */
        // IMAGE SECTION OF THE POST
        GestureDetector(
          onDoubleTap: () {
            FireStoreMethods().likePost(
              widget.snap['postId'].toString(),
              user.uid,
              widget.snap['likes'],
            );
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
        LikeAnimation(
          isAnimating: isLikeAnimating,
          duration: const Duration(
            milliseconds: 400,
          ),
          onEnd: () {
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Icon(
            Icons.favorite,
            color: Colors.white,
            size: 100,
          ),
        ),

        Row(children: <Widget>[
          LikeAnimation(
            isAnimating: false,
            //widget.
            // snap["likes"].toString(),
            //.contains(user.uid),
            smallLike: true,
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                FireStoreMethods().likePost(widget.snap['postId'].toString(),
                    user.uid, widget.snap['likes']);
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.comment_outlined,
            ),
    //        onPressed: ()
    onPressed: () => Navigator.of(context).push(
    MaterialPageRoute(
    builder: (context) => CommentsScreen(
    snap: widget.snap['postId'].toString(),
    ),

    )
    ),),
          IconButton(
            icon: Icon(
              Icons.send,
            ),
            onPressed: () {},
          ),
          Expanded(
              child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          )),
        ]),

        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${widget.snap['likes'].length} like",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: widget.snap["userName"] //.toString()
                          ,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: widget.snap["description"] //"key description"
                          ,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ])),
                  ),
                  InkWell(
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "view all ${commentLen} comment",
                          style: const TextStyle(
                            color: secondaryColor,
                          ),
                        )),
                  )
                ]))
      ]),
    );
  }
}
