import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nstagram/models/user.dart' as model;
import 'package:nstagram/presentation/screen/comments_screen.dart';
import 'package:nstagram/presentation/widget/comment_card.dart';
import 'package:nstagram/presentation/widget/like_animation.dart';
import 'package:nstagram/provider/user_provider.dart';
import 'package:nstagram/resources/firestore_methods.dart';
import 'package:nstagram/resources/storage_methods.dart';
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

  List<Reference> file = [];
  int commentLen = 0;

  List likes = [];
  int like = 0;
  bool islike = false;

  @override
  void initState() {
    super.initState();
      fetchCommentLen();
    fetchLike();
    //print(islike);
  }

  Future<int> fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.snap['postId'])
          .collection('comment')
          .get();
      //commentLen++;
      commentLen = snap.docs.length; // length;
      print("ggggggggggggggggghhhhhhhhhh$commentLen");
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {
      commentLen++;
    });
    return commentLen;
  }

  Future<int> fetchLike() async {
    try {
      //QuerySnapshot
      var snap = await FirebaseFirestore.instance
          .collection("post")
          .doc(widget.snap["postId"])
          .get();

      likes = snap.data()!["likes"];
      like = likes.length;
      print("$like 222222222222");
    } catch (e) {
      print(e);
    }

    setState(() {
     // like++;
     islike=true;
    });
print(islike);
    return like;
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      child: Column(children: [
        // HEADER SECTION OF THE POST
        Container(
          color:mobileBackgroundColor ,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 16,
          ).copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.snap["profImage"])),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Column(children: [
                Text(
                  widget.snap["username"],
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
                                  onTap: () {
                                    FireStoreMethods().deletePost(
                                        widget.snap["postId"].toString());
                                    Navigator.of(context).pop();
                                  },
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

        // IMAGE SECTION OF THE POST
        GestureDetector(
          //onDoubleTap: () {
          onTap: () {
            setState(() {
              isLikeAnimating = true;
            });
            FireStoreMethods().likePost(
              widget.snap['postId'].toString(),
              user.uid,
              widget.snap['likes'],
            );
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
            ],
          ),
        ),

        Row(

            children: <Widget>[

          IconButton(
          icon:

        widget.snap['likes'].contains(user.uid) ?

          Icon(Icons.favorite,
          color: Colors
               .red)
                         :
          Icon(Icons.favorite,
    color: Colors
        .white),//: Icon(Icons.favorite, color: Colors.red)
          onPressed: () {
            FireStoreMethods().likePost(
              widget.snap['postId'].toString(),
              user.uid,
              widget.snap['likes'],
            );
          }
            ),
    //      // // fetchLike();
    //      //  like--;
    //      //  setState(() {
    //      //  islike = false;
    //      //  });
    //      //  },
    //       ),
    // :IconButton(
          //         icon: Icon(Icons.favorite, color: Colors.white),
          //         //    onPressed: (){},
          //         onPressed: () {
          //             FireStoreMethods().likePost(
          //               widget.snap['postId'].toString(),
          //               user.uid,
          //               widget.snap['likes'],
          //
          //            );
          //           // fetchLike();
          //           like--;
          //           setState(() {
          //             islike = true;
          //           });
          //
          //           //  like++;
          //         },
          //       ),
          IconButton(
            icon: Icon(
              Icons.comment_outlined,
            ),
            //        onPressed: ()
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CommentsScreen(
                snap: widget.snap['postId'].toString(),
              ),
            )),
          ),
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
                  //  islike
                  //   //
                 Text("$like like", style:TextStyle(color: Colors.white,)),
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
                          text: widget.snap["description"]
                          //"key description"
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
  void uploaded() async {
   List<Reference>?result=await StorageMethods().getFile();
if(result!= null){

  setState(() {
    file=result;
  });
}

  }

}
// "https://images.unsplash.com/photo-1729027399111-e301fa0e14fa?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
